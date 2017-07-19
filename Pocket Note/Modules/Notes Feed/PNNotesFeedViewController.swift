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
 The `PNNotesFeedViewController` class is a custom view controller for the Notes List module.
 */
class PNNotesFeedViewController: UIViewController, NoteFeedMenu {
    public var AlertAction = UIAlertAction.self
    
    /// A `PNNotesFeedView` instance representing the super view of the current view controller.
    fileprivate let baseView: PNNotesFeedView? = {
        if let view = Bundle.main.loadNibNamed("PNNotesFeedView", owner: self, options: nil)![0] as? PNNotesFeedView {
            return view
        }
        return nil
    }()
    
    /// An option `Notebook` instance representing the current notebook shown to the user.
    fileprivate var currentNotebook: Notebook? {
        didSet {
            if let menuViewController = self.parent {
                self.searchNoteInteractor?.updateNoteList(searchText: self.searchText, currentNotebook: self.currentNotebook, notebookFilter: notebookFilter, menuViewController: menuViewController)
                self.notesFeedTableViewInteractor?.notebookFilter = notebookFilter
            }
        }
    }
    
    /// An optional `String` value representing the search text inputted by the user.
    fileprivate var searchText: String? {
        didSet {
            if let menuViewController = self.parent {
                self.searchNoteInteractor?.updateNoteList(searchText: self.searchText, currentNotebook: self.currentNotebook, notebookFilter: notebookFilter, menuViewController: menuViewController)
                self.notesFeedTableViewInteractor?.notebookFilter = notebookFilter
            }
        }
    }
    
    /// An `NSPredicate` instance representing the predicate filter affected by the value current notebook  and the search text.
    fileprivate var notebookFilter: NSPredicate = {
        return NSPredicate.init(format: "dateCreated != nil")
    }()
    
    /// A `NotificationToken` instance that holds the token for the notification block of the notes list.
    fileprivate var notificationToken: NotificationToken?
    
    /// A `PNNotesTableViewInteractor` instance for the table view logic of this view controller.
    fileprivate var notesFeedTableViewInteractor: PNNotesTableViewInteractor?
    /// A `PNDeleteNoteInteractor` instance for the delete note logic.
    internal var deleteNoteInteractor: PNDeleteNoteInteractor?
    /// A `PNDeleteNotebookInteractor` instance for the delete notebook logic.
    internal var deleteNotebookInteractor: PNDeleteNotebookInteractor?
    /// A `PNSearchNoteInteractor` instance for the search note list logic.
    fileprivate var searchNoteInteractor: PNSearchNoteInteractor?
    /// A `PNNotesEditNotebookInteractor` instance for the edit notebok logic.
    fileprivate var notesEditNotebookInteractor: PNNotesEditNotebookInteractor?

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
            
            let deleteNotebookPresenter = PNDeleteNotebookPresenter.init(presenterOutput: self)
            deleteNotebookInteractor = PNDeleteNotebookInteractor.init(realm: unwrappedRealm, deleteNotebookPresenter: deleteNotebookPresenter)
        }
        
        notesEditNotebookInteractor = PNNotesEditNotebookInteractor.init(presentationContext: self, navigationItem: navigationItem, navigationController: navigationController, deleteNotebookInteractor: deleteNotebookInteractor, AlertAction: AlertAction, delegate: self, currentNotebook: currentNotebook)
        
        if let notesListTableView = baseView?.notesListTableView, let unwrappedDeleteInteractor = deleteNoteInteractor {
            let notesTableViewPresenter = PNNotesTableViewPresenter.init(presenterOutput: self)
            notesFeedTableViewInteractor = PNNotesTableViewInteractor.init(notesListTableView: notesListTableView, currentNotebook: currentNotebook, deleteNoteInteractor: unwrappedDeleteInteractor, notebookFilter: notebookFilter, notesTableViewPresenter: notesTableViewPresenter)
        }
        
        if let notesListTableView = baseView?.notesListTableView, let unwrappedNotesEditNotebookInteractor = notesEditNotebookInteractor, let unwrappedParentViewController = parent {
            let searchNotePresenter = PNSearchNotePresenter.init(presenterOutput: self)
            searchNoteInteractor = PNSearchNoteInteractor.init(navigationItem: navigationItem, navigationBar: navigationController?.navigationBar, currentNotebook: currentNotebook, noteListTableView: notesListTableView, notesEditNotebookInteractor: unwrappedNotesEditNotebookInteractor, searchNotePresenter: searchNotePresenter, presentationContext: self, menuPresentationContext: unwrappedParentViewController)
        }
    }
    
    /**
     Shows the list of notebooks view controller.
     */
    @objc internal func openNotebooks() {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let unwrappedNotebookListViewController = mainStoryboard.instantiateViewController(withIdentifier: "PNNotebooksListViewController") as? PNNotebooksListViewController else {
            print("Notebook List View Controller is nil")
            return
        }
        unwrappedNotebookListViewController.output = self
        present(unwrappedNotebookListViewController, animated: true, completion: nil)
    }

}

extension PNNotesFeedViewController: PNNotesTableViewPresenterOutput {
    internal func openMoveNoteToANotebook(note: Note) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let unwrappedMoveNoteViewController = mainStoryboard.instantiateViewController(withIdentifier: "PNMoveNoteViewController") as? PNMoveNoteViewController else {
            print("Move Note Controller is nil")
            return
        }
        unwrappedMoveNoteViewController.note = note
        present(unwrappedMoveNoteViewController, animated: true, completion: nil)
    }
    
    internal func pushToCreateNote() {
        let createNoteViewController = PNCreateNoteViewController()
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return }
        
        let noteList = unwrappedRealm.objects(Note.self).filter(notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
        createNoteViewController.notebook = currentNotebook
        
        if let selectedIndexPath = baseView?.notesListTableView.indexPathForSelectedRow {
            createNoteViewController.note =  noteList[selectedIndexPath.row]
            baseView?.notesListTableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        navigationController?.pushViewController(createNoteViewController, animated: true)
    }
}

extension PNNotesFeedViewController: PNNotesFeedViewDelegate {
    /**
     Handles the add note button action.
     */
    internal func addNoteButtonTapped() {
        pushToCreateNote()
    }
}

extension PNNotesFeedViewController: UISearchBarDelegate {
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if baseView?.searchBar == searchBar {
            self.searchText = searchText
        }
    }
    
    internal func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if baseView?.searchBar == searchBar {
            self.searchText = searchBar.text
            searchBar.showsCancelButton = true
        }
    }
    
    internal func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if baseView?.searchBar == searchBar {
            searchBar.showsCancelButton = false
        }
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension PNNotesFeedViewController: UIPopoverPresentationControllerDelegate {
    public func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.sourceView = self.navigationController?.navigationBar
        popoverPresentationController.sourceRect = (self.navigationController?.navigationBar.frame)!
    }
}

extension PNNotesFeedViewController: PNSearchNotePresenterOutput {
    internal func update(notebookFilter: NSPredicate) {
        self.notebookFilter = notebookFilter
    }
    
    internal func update(searchText: String?) {
        self.searchText = searchText
    }
}

extension PNNotesFeedViewController: PNDeleteNotebookPresenterOutput, PNNotebooksListViewControllerOutput {
    internal func update(currentNotebook: Notebook?) {
        self.currentNotebook = currentNotebook
    }
}
