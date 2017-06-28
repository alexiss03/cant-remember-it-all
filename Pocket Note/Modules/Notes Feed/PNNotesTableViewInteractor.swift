//
//  PNNotesTableViewInteractor.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

class PNNotesTableViewInteractor: NSObject, UITableViewDelegate, UITableViewDataSource {
    private var notebookFeedViewController: PNNotesFeedViewControllerProtocol
    private var notesFeedView: PNNotesFeedViewProtocol
    private var presentationContext: UIViewController
    
    public required init(presentationContext: UIViewController, notesListTableView: UITableView, notebookFeedViewController: PNNotesFeedViewControllerProtocol, notesFeedView: PNNotesFeedViewProtocol) {
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
    
    // MARK: UITableViewDelegate Methods
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentationContext.performSegue(withIdentifier: "TO_CREATE_NOTE", sender: self)
    }
    
    // MARK: UITableViewDataSource Methods
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
    
    private func editRowAction(indexPath: IndexPath) -> UITableViewRowAction {
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
    
    private func deleteRowAction(indexPath: IndexPath) -> UITableViewRowAction {
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