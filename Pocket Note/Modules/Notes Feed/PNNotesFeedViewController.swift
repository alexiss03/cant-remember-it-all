//
//  PNNotesFeedViewController.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift
import SlideMenuControllerSwift

/**
 A `PNCurrentNotesContainer` protocol representing a container of the current notebook property.
 */
protocol PNCurrentNotesContainer: class {
    var currentNotebook: Notebook? { get set }
}

/**
 A `PNNotebookFilterContainer` protocol representing a container of the notebook filter property.
 */
protocol PNNotebookFilterContainer: class {
    var notebookFilter: NSPredicate { get set }
}

/**
 A `PNNotebookFilterContainer` protocol representing `PNNotesFeedViewController` properties and methods.
 */
protocol PNNotesFeedViewControllerProtocol {
    var notebookFilter: NSPredicate { get set }
    var navigationItem: UINavigationItem { get }
    var navigationController: UINavigationController? { get }
    var deleteNoteInteractor: PNDeleteNoteInteractor? { get set }
    var deleteNotebookInteractor: PNDeleteNotebookInteractor? { get set }
    
    func openMoveNoteToANotebook(note: Note)
    func setNotebookButton(editNotebookInteractor: PNNotesEditNotebookInteractor?, currentNotebook: Notebook?, navigationItem: UINavigationItem)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)?)
}

/**
 The `PNNotesFeedViewController` class is a custom view controller for the Notes List module.
 */
class PNNotesFeedViewController: UIViewController, PNCurrentNotesContainer, PNNotesFeedViewControllerProtocol, NoteFeedMenu, PNNotebookFilterContainer {
    var AlertAction = UIAlertAction.self
    
    /// A `PNNotesFeedView` instance representing the super view of the current view controller.
    let baseView: PNNotesFeedView? = {
        if let view = Bundle.main.loadNibNamed("PNNotesFeedView", owner: self, options: nil)![0] as? PNNotesFeedView {
            return view
        }
        return nil
    }()
    
    /// An option `Notebook` instance representing the current notebook shown to the user.
    var currentNotebook: Notebook? {
        didSet {
            if let menuViewController = self.parent {
                self.searchNoteInteractor?.updateNoteList(searchText: self.searchText, currentNotebook: self.currentNotebook, notebookFilterContainer: self, menuViewController: menuViewController)
            }
        }
    }
    
    /// An optional `String` value representing the search text inputted by the user.
    var searchText: String? {
        didSet {
            if let menuViewController = self.parent {
                self.searchNoteInteractor?.updateNoteList(searchText: self.searchText, currentNotebook: self.currentNotebook, notebookFilterContainer: self, menuViewController: menuViewController)
            }
        }
    }
    
    /// An `NSPredicate` instance representing the predicate filter affected by the value current notebook  and the search text.
    var notebookFilter: NSPredicate = {
        return NSPredicate.init(format: "dateCreated != nil")
    }()
    
    /// A `NotificationToken` instance that holds the token for the notification block of the notes list.
    var notificationToken: NotificationToken?
    
    /// A `PNNotesTableViewInteractor` instance for the table view logic of this view controller.
    fileprivate var notesFeedTableViewInteractor: PNNotesTableViewInteractor?
    /// A `PNDeleteNoteInteractor` instance for the delete note logic.
    internal var deleteNoteInteractor: PNDeleteNoteInteractor?
    /// A `PNDeleteNotebookInteractor` instance for the delete notebook logic.
    internal var deleteNotebookInteractor: PNDeleteNotebookInteractor?
    /// A `PNSearchNoteInteractor` instance for the search note list logic.
    fileprivate var searchNoteInteractor: PNSearchNoteInteractor?
    /// A `PNNotesEditNotebookInteractor` instance for the edit notebok logic.
    internal var notesEditNotebookInteractor: PNNotesEditNotebookInteractor?

    internal override func viewDidLoad() {
        super.viewDidLoad()
        if let unwrappedBaseView = baseView {
            unwrappedBaseView.frame = self.view.frame
            view = unwrappedBaseView
            
            unwrappedBaseView.searchBar.delegate = self
            unwrappedBaseView.delegate = self
            unwrappedBaseView.setContent()
            
            if let slideController = self.parent {
                setMenu(title: "MEMO", target: self, action: #selector(self.openNotebooks), viewController: self, slideController: slideController)
            }
            
            initInteractors()
        }
        
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchNoteInteractor?.tableAddNotificationBlock(noteFilter: notebookFilter)
    }
    
    internal override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    /**
     Initializes the logic interactors.
     */
    private func initInteractors() {
        if let unwrappedRealm = PNSharedRealm.realmInstance() {
            deleteNoteInteractor = PNDeleteNoteInteractor.init(realm: unwrappedRealm)
            deleteNotebookInteractor = PNDeleteNotebookInteractor.init(realm: unwrappedRealm)
        }
        
        notesEditNotebookInteractor = PNNotesEditNotebookInteractor.init(presentationContext: self, navigationItem: navigationItem, navigationController: navigationController, deleteNotebookInteractor: deleteNotebookInteractor, AlertAction: AlertAction, delegate: self, currentNotebookHolder: self)
        
        if let notesListTableView = baseView?.notesListTableView {
            notesFeedTableViewInteractor = PNNotesTableViewInteractor.init(presentationContext: self, notesListTableView: notesListTableView, notebookFeedViewController: self, notesFeedView: self)
        }
        
        if let notesListTableView = baseView?.notesListTableView, let unwrappedNotesEditNotebookInteractor = notesEditNotebookInteractor {
            searchNoteInteractor = PNSearchNoteInteractor.init(navigationItem: navigationItem, navigationBar: navigationController?.navigationBar, notesFeedViewController: self, noteListTableView: notesListTableView, notesEditNotebookInteractor: unwrappedNotesEditNotebookInteractor)
        }
    }
    
    /**
     Shows the list of notebooks view controller.
     */
    @objc func openNotebooks() {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let unwrappedNotebookListViewController = mainStoryboard.instantiateViewController(withIdentifier: "PNNotebooksListViewController") as? PNNotebooksListViewController else {
            print("Notebook List View Controller is nil")
            return
        }
        unwrappedNotebookListViewController.notesFeedDelegate = self
        present(unwrappedNotebookListViewController, animated: true, completion: nil)
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? PNCreateNoteViewController {
            guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return }
        
            let noteList = unwrappedRealm.objects(Note.self).filter(notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
            destinationViewController.notebook = currentNotebook
            
            if let selectedIndexPath = baseView?.notesListTableView.indexPathForSelectedRow {
                destinationViewController.note =  noteList[selectedIndexPath.row]
                baseView?.notesListTableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    internal func openMoveNoteToANotebook(note: Note) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let unwrappedMoveNoteViewController = mainStoryboard.instantiateViewController(withIdentifier: "PNMoveNoteViewController") as? PNMoveNoteViewController else {
            print("Move Note Controller is nil")
            return
        }
        unwrappedMoveNoteViewController.note = note
        present(unwrappedMoveNoteViewController, animated: true, completion: nil)
    }
}

extension PNNotesFeedViewController: PNNotesFeedViewDelegate {
    /**
     Handles the add note button action.
     */
    func addNoteButtonTapped() {
        performSegue(withIdentifier: "TO_CREATE_NOTE", sender: self)
    }
}

extension PNNotesFeedViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if baseView?.searchBar == searchBar {
            self.searchText = searchText
        }
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if baseView?.searchBar == searchBar {
            self.searchText = searchBar.text
            searchBar.showsCancelButton = true
        }
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if baseView?.searchBar == searchBar {
            searchBar.showsCancelButton = false
        }
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension PNNotesFeedViewController: UIPopoverPresentationControllerDelegate {
    public func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.sourceView = self.navigationController?.navigationBar
        popoverPresentationController.sourceRect = (self.navigationController?.navigationBar.frame)!
    }
}
