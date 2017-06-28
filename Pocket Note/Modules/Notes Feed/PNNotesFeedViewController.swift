//
//  PNNotesFeedViewController.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

protocol PNNotesFeedViewProtocol: class {
    var currentNotebook: Notebook? { get set }
}

protocol PNNotebookFilterContainer: class {
    var notebookFilter: NSPredicate { get set }
}

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

class PNNotesFeedViewController: UIViewController, PNNotesFeedViewProtocol, PNNotesFeedViewControllerProtocol, NoteFeedMenu, PNNotebookFilterContainer {
    var AlertAction = UIAlertAction.self
    
    let baseView: PNNotesFeedView? = {
        if let view = Bundle.main.loadNibNamed("PNNotesFeedView", owner: self, options: nil)![0] as? PNNotesFeedView {
            return view
        }
        return nil
    }()
    
    var currentNotebook: Notebook? {
        didSet {
            self.searchNoteInteractor?.updateNoteList(searchText: self.searchText, currentNotebook: self.currentNotebook, notebookFilterContainer: self)
        }
    }
    
    var searchText: String? {
        didSet {
            self.searchNoteInteractor?.updateNoteList(searchText: self.searchText, currentNotebook: self.currentNotebook, notebookFilterContainer: self)
        }
    }
    
    var notebookFilter: NSPredicate = {
        return NSPredicate.init(format: "dateCreated != nil")
    }()
    
    var notificationToken: NotificationToken?
    
    var notesFeedTableViewInteractor: PNNotesTableViewInteractor?
    var deleteNoteInteractor: PNDeleteNoteInteractor?
    var deleteNotebookInteractor: PNDeleteNotebookInteractor?
    var searchNoteInteractor: PNSearchNoteInteractor?
    var notesEditNotebookInteractor: PNNotesEditNotebookInteractor?

    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedBaseView = baseView {
            unwrappedBaseView.frame = self.view.frame
            view = unwrappedBaseView
            setMenu(title: "MEMO", target: self, action: #selector(self.openNotebooks), navigationItem: self.navigationItem, navigationBar: self.navigationController?.navigationBar)
            unwrappedBaseView.searchBar.delegate = self
            unwrappedBaseView.delegate = self
            
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
        }
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension PNNotesFeedViewController: UIPopoverPresentationControllerDelegate {
    public func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.sourceView = self.navigationController?.navigationBar
        popoverPresentationController.sourceRect = (self.navigationController?.navigationBar.frame)!
    }
}
