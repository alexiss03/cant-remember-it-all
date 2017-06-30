//
//  PNSearchNoteInteractor.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

/**
 The `PNSearchNoteInteractor` contains the business logic for Search module.
*/
class PNSearchNoteInteractor: NoteFeedMenu {
    /// A `UINavigationItem` instance  where the notebook name is displayed.
    private var navigationItem: UINavigationItem
    /// A  `UINavigationBar` instance  where the update note button is located.
    private var navigationBar: UINavigationBar?
    /// A `PNCurrentNotesContainer` instance  referring to a `PNNotesFeedViewController`.
    private var notesFeedViewController: PNCurrentNotesContainer
    /// A `UITableView` instance containing the list of notes is displayed.
    private var noteListTableView: UITableView
    /// A `PNNotesEditNotebookInteractor` editing a `Notebook` instance.
    private var notesEditNotebookInteractor: PNNotesEditNotebookInteractor
    
    /// A `NotificationToken` instance holding the listener to the changes to the current note list.
    var notificationToken: NotificationToken?
    
    /**
     Initializes the instance.
     
     - Parameter navigationItem: A `UINavigationItem` instance  where the notebook name is displayed.
     - Parameter navigationBar: A  `UINavigationBar` instance  where the update note button is located.
     - Parameter notesFeedViewController: A `PNCurrentNotesContainer` instance  referring to a `PNNotesFeedViewController`.
     - Parameter noteListTableView: A `UITableView` instance containing the list of notes is displayed.
     - Parameter notesEditNotebookInteractor: A `PNNotesEditNotebookInteractor` editing a `Notebook` instance.
     */
    init(navigationItem: UINavigationItem, navigationBar: UINavigationBar?, notesFeedViewController: PNCurrentNotesContainer, noteListTableView: UITableView, notesEditNotebookInteractor: PNNotesEditNotebookInteractor) {
        self.navigationItem = navigationItem
        self.navigationBar = navigationBar
        self.notesFeedViewController = notesFeedViewController
        self.noteListTableView = noteListTableView
        self.notesEditNotebookInteractor = notesEditNotebookInteractor
    }
    
    /**
     Updates the list of notes. 
     
     This updates the filter predicate of the table view. Next, it stops the notification listener of the previous result query in `Realm`. Lastly, queries the new list of notes to be displayed in the table view list.
     - Parameter searchText: A `String` to be searched in the content of the existing notes.
     - Parameter currentNotebook: A `Notebook` instance currently loaded in the screen.
     - Parameter notebookFilterContainer: A `PNNotebookFilterContainer` instance that cotains the filter predicate.
     */
    internal func updateNoteList(searchText: String?, currentNotebook: Notebook?, notebookFilterContainer: PNNotebookFilterContainer) {
        DispatchQueue.main.async {
            if let unwrappedSearchText = searchText, let unwrappedCurrentNotebook = currentNotebook, let notebookName = unwrappedCurrentNotebook.name {
                notebookFilterContainer.notebookFilter = NSPredicate.init(format: "notebook == %@ && (body CONTAINS[c] %@ || title CONTAINS[c] %@)", unwrappedCurrentNotebook, unwrappedSearchText, unwrappedSearchText)
                self.setMenu(title: notebookName, target: self.notesFeedViewController, action: #selector(PNNotesFeedViewController.openNotebooks), navigationItem: self.navigationItem, navigationBar: self.navigationBar)
            } else if let unwrappedSearchText = searchText, currentNotebook == nil {
                notebookFilterContainer.notebookFilter = NSPredicate.init(format: "body CONTAINS[c] %@ || title CONTAINS[c] %@", unwrappedSearchText, unwrappedSearchText)
                self.setMenu(title: "MEMO", target: self.notesFeedViewController, action: #selector(PNNotesFeedViewController.openNotebooks), navigationItem: self.navigationItem, navigationBar: self.navigationBar)
            } else if let unwrappedCurrentNotebook = currentNotebook, let notebookName = unwrappedCurrentNotebook.name, searchText == nil {
                notebookFilterContainer.notebookFilter = NSPredicate.init(format: "notebook == %@", unwrappedCurrentNotebook)
                self.setMenu(title: notebookName, target: self.notesFeedViewController, action: #selector(PNNotesFeedViewController.openNotebooks), navigationItem: self.navigationItem, navigationBar: self.navigationBar)
            } else {
                notebookFilterContainer.notebookFilter = NSPredicate.init(format: "dateCreated != nil")
                self.setMenu(title: "MEMO", target: self.notesFeedViewController, action: #selector(PNNotesFeedViewController.openNotebooks), navigationItem: self.navigationItem, navigationBar: self.navigationBar)
            }
            
            self.notificationToken?.stop()
            
            self.setNotebookButton(editNotebookInteractor: self.notesEditNotebookInteractor, currentNotebook: currentNotebook, navigationItem: self.navigationItem)
            self.tableAddNotificationBlock(noteFilter: notebookFilterContainer.notebookFilter)
            
        }
    }
    
    /**
     Adds notification block to the table view
     - Parameter noteFilter: An `NSPredicate` instance filtering a list of `Notes`.
     */
    internal func tableAddNotificationBlock(noteFilter: NSPredicate) {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return }
        let results = unwrappedRealm.objects(Note.self).filter(noteFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
    
        notificationToken = results.addNotificationBlock(noteListTableView.applyChanges)
    }
}
