//
//  PNMoveNoteTableViewInteractor.swift
//  Memo
//
//  Created by Hanet on 7/19/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

class PNMoveNoteTableViewInteractor: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let moveNoteInteractor: PNMoveNoteInteractor
    private let noteToMove: Note
    private let moveNoteTableViewPresenter: PNMoveNoteTableViewPresenter
    
    init(noteToMove: Note, tableView: UITableView, moveNoteInteractor: PNMoveNoteInteractor, moveNoteTableViewPresenter: PNMoveNoteTableViewPresenter) {
        self.noteToMove = noteToMove
        self.moveNoteInteractor = moveNoteInteractor
        self.moveNoteTableViewPresenter = moveNoteTableViewPresenter
        super.init()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let tableViewCellNib = UINib.init(nibName: "PNNotebooksListTableViewCell", bundle: Bundle.main)
        tableView.register(tableViewCellNib, forCellReuseIdentifier: "PNNotebooksListTableViewCell")
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return 0 }
        let notebookList = unwrappedRealm.objects(Notebook.self)
        
        return notebookList.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PNNotebooksListTableViewCell") as? PNNotebooksListTableViewCell {
            guard let unwrappedRealm = PNSharedRealm.realmInstance() else {  return UITableViewCell.init() }
            let notebookList = unwrappedRealm.objects(Notebook.self).sorted(byKeyPath: "dateCreated", ascending: true)
            cell.setContent(notebook: notebookList[indexPath.row])
            cell.selectionStyle = .none
            
            return cell
        }
        return UITableViewCell.init()
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        moveNoteInteractor.move(note: noteToMove, position: indexPath.row)
        moveNoteTableViewPresenter.dismiss()
    }
}
