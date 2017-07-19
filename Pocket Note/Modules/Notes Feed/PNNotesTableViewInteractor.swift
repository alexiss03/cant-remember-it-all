//
//  PNNotesTableViewInteractor.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

/**
 The `PNNotesTableViewInteractor` class contains the business logic for hte table view in the notes list.
 */
class PNNotesTableViewInteractor: NSObject {
    
    fileprivate var currentNotebook: Notebook?
    
    fileprivate var notesListTableView: UITableView
    fileprivate var deleteNoteInteractor: PNDeleteNoteInteractor
    internal var notebookFilter: NSPredicate
    fileprivate var notesTableViewPresenter: PNNotesTableViewPresenter
    
    /**
     Initializes the instance.
     */
    internal init(notesListTableView: UITableView, currentNotebook: Notebook?, deleteNoteInteractor: PNDeleteNoteInteractor, notebookFilter: NSPredicate, notesTableViewPresenter: PNNotesTableViewPresenter) {
        self.notesListTableView = notesListTableView
        self.currentNotebook = currentNotebook
        self.deleteNoteInteractor = deleteNoteInteractor
        self.notebookFilter = notebookFilter
        self.notesTableViewPresenter = notesTableViewPresenter
        super.init()
        
        notesListTableView.delegate = self
        notesListTableView.dataSource = self
        notesListTableView.rowHeight = UITableViewAutomaticDimension
        notesListTableView.estimatedRowHeight = 75
        notesListTableView.emptyDataSetSource = self
        
        let tableViewCellNib = UINib.init(nibName: "PNNotesFeedTableViewCell", bundle: Bundle.main)
        let tableViewCellNibId = "PNNotesFeedTableViewCell"
        notesListTableView.register(tableViewCellNib, forCellReuseIdentifier: tableViewCellNibId)
    }

    /**
     Creates an edit action for the table view.
     
      - Parameter indexPath: A `IndexPath` instance receiving the row action.
     */
    fileprivate func editRowAction(indexPath: IndexPath) -> UITableViewRowAction {
        let editAction = UITableViewRowAction(style: .default, title: "Move", handler: { (_, _) in
            print("Move tapped")
            
            guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return }
            
            let noteList = unwrappedRealm.objects(Note.self).filter(self.notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
            self.notesTableViewPresenter.openMoveNoteToANotebook(note: noteList[indexPath.row])
        })
        editAction.backgroundColor = PNConstants.blueColor

        return editAction
    }
    
    /**
     Creates an delete action for the table view.
     
     - Parameter indexPath: A `IndexPath` instance receiving the row action.
     */
    fileprivate func deleteRowAction(indexPath: IndexPath) -> UITableViewRowAction {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (_, _) in
            self.deleteNoteInteractor.deleteSelectedNote(indexPath: indexPath, filter: self.notebookFilter)
        })
        deleteAction.backgroundColor = PNConstants.redColor
        return deleteAction
    }
}

extension PNNotesTableViewInteractor: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notesTableViewPresenter.pushToCreateNote()
    }
}

extension PNNotesTableViewInteractor: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return 0 }
        
        let noteList = unwrappedRealm.objects(Note.self).filter(notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
        return noteList.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PNNotesFeedTableViewCell") as? PNNotesFeedTableViewCell {
            guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return UITableViewCell.init() }
            let noteList = unwrappedRealm.objects(Note.self).filter(notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
            
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

extension PNNotesTableViewInteractor: DZNEmptyDataSetSource {
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if scrollView == notesListTableView, currentNotebook !=  NSPredicate.init(format: "dateCreated != nil") {
            let attributes = [NSFontAttributeName: UIFont.init(name: "Lato", size: 20.0) as Any, NSForegroundColorAttributeName: UIColor.lightGray] as [String: Any]
            return NSAttributedString.init(string: "No Notes Found", attributes: attributes)
        } else if scrollView == notesListTableView, currentNotebook == nil {
            let attributes = [NSFontAttributeName: UIFont.init(name: "Lato", size: 20.0) as Any, NSForegroundColorAttributeName: UIColor.lightGray] as [String: Any]
            return NSAttributedString.init(string: "No Notes Yet", attributes: attributes)
        } else {
            let attributes = [NSFontAttributeName: UIFont.init(name: "Lato", size: 20.0) as Any, NSForegroundColorAttributeName: UIColor.lightGray] as [String: Any]
            return NSAttributedString.init(string: "Empty Notebook", attributes: attributes)
        }
    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if scrollView == notesListTableView, currentNotebook !=  NSPredicate.init(format: "dateCreated != nil") {
            let attributes = [NSFontAttributeName: UIFont.init(name: "Lato-Light", size: 16.0) as Any, NSForegroundColorAttributeName: UIColor.lightGray] as [String: Any]
            return NSAttributedString.init(string: "No notes match your search.", attributes: attributes)
        } else if scrollView == notesListTableView, currentNotebook == nil {
            let attributes = [NSFontAttributeName: UIFont.init(name: "Lato-Light", size: 16.0) as Any, NSForegroundColorAttributeName: UIColor.lightGray] as [String: Any]
            return NSAttributedString.init(string: "Start adding notes that you can sync across your iOS devices.", attributes: attributes)
        } else {
            let attributes = [NSFontAttributeName: UIFont.init(name: "Lato-Light", size: 16.0) as Any, NSForegroundColorAttributeName: UIColor.lightGray] as [String: Any]
            return NSAttributedString.init(string: "Start adding notes in this notebook that you can sync across your iOS devices.", attributes: attributes)

        }
    }
}
