//
//  PNNotesTableViewInteractor.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

/**
 The `PNNotesTableViewInteractor` class contains the business logic for hte table view in the notes list.
 */
class PNNotesTableViewInteractor: NSObject {
    /// A `PNNotesFeedViewControllerProtocol` instance representing the controller for notes list.
    fileprivate var notebookFeedViewController: PNNotesFeedViewControllerProtocol
    /// A `PNCurrentNotesContainer` instance representing an object container for currentNotebook in notes feed.
    fileprivate var notesFeedView: PNCurrentNotesContainer
    /// A `UIViewController` instance representing the view controller where segues are to be performed.
    fileprivate var presentationContext: UIViewController
    
    /**
     Initializes the instance.
      
     - Parameter presentationContext: A `UIViewController` instance representing the view controller where segues are to be performed.
     - Parameter notesListTableView: A `UITableView` instance where the list of notes is displayed.
     - Parameter notebookFeedViewController: A `PNNotesFeedViewControllerProtocol` instance representing the controller for notes list.
     - Parameter notesFeedView: A `PNCurrentNotesContainer` instance representing an object container for currentNotebook in notes feed.
     */
    public required init(presentationContext: UIViewController, notesListTableView: UITableView, notebookFeedViewController: PNNotesFeedViewControllerProtocol, notesFeedView: PNCurrentNotesContainer) {
        self.notebookFeedViewController = notebookFeedViewController
        self.notesFeedView = notesFeedView
        self.presentationContext = presentationContext
        super.init()
        
        notesListTableView.delegate = self
        notesListTableView.dataSource = self
        
        let tableViewCellNib = UINib.init(nibName: "PNNotesFeedTableViewCell", bundle: Bundle.main)
        let tableViewCellNibId = "PNNotesFeedTableViewCell"
        notesListTableView.register(tableViewCellNib, forCellReuseIdentifier: tableViewCellNibId)
    }

    /**
     Creates an edit action for the table view.
     
      - Parameter indexPath: A `IndexPath` instance receiving the row action.
     */
    fileprivate func editRowAction(indexPath: IndexPath) -> UITableViewRowAction {
        weak var weakSelf = self
        let editAction = UITableViewRowAction(style: .default, title: "Move", handler: { (_, _) in
            print("Move tapped")
            
            guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return }
            guard let strongSelf = weakSelf else { return }
            
            let noteList = unwrappedRealm.objects(Note.self).filter(strongSelf.notebookFeedViewController.notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
            strongSelf.notebookFeedViewController.openMoveNoteToANotebook(note: noteList[indexPath.row])
        })
        editAction.backgroundColor = PNConstants.blueColor

        return editAction
    }
    
    /**
     Creates an delete action for the table view.
     
     - Parameter indexPath: A `IndexPath` instance receiving the row action.
     */
    fileprivate func deleteRowAction(indexPath: IndexPath) -> UITableViewRowAction {
        weak var weakSelf = self
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (_, _) in
            guard let strongSelf = weakSelf else {
                print("Weak self is nil")
                return
            }
            strongSelf.notebookFeedViewController.deleteNoteInteractor?.deleteSelectedNote(indexPath: indexPath, filter: strongSelf.notebookFeedViewController.notebookFilter)
        })
        deleteAction.backgroundColor = PNConstants.redColor
        return deleteAction
    }
}

extension PNNotesTableViewInteractor: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentationContext.performSegue(withIdentifier: "TO_CREATE_NOTE", sender: self)
    }
}

extension PNNotesTableViewInteractor: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return 0 }
        
        let noteList = unwrappedRealm.objects(Note.self).filter(notebookFeedViewController.notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
        return noteList.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PNNotesFeedTableViewCell") as? PNNotesFeedTableViewCell {
            guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return UITableViewCell.init() }
            let noteList = unwrappedRealm.objects(Note.self).filter(notebookFeedViewController.notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
            
            cell.setContent(note: noteList[indexPath.row])
            cell.selectionStyle = .none
            cell.isEditing = true
            cell.editingAccessoryView = UITableViewCell.init()
            return cell
        }
        return UITableViewCell.init()
    }
    
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        } else if editingStyle == .insert {
            
        }
    }
    
    internal func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = editRowAction(indexPath: indexPath)
        let deleteAction = deleteRowAction(indexPath: indexPath)
        
        return [deleteAction, editAction]
    }

}
