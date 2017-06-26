//
//  PNCreateNotebookOperation.swift
//  Memo
//
//  Created by Hanet on 6/23/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import ProcedureKit
import RealmSwift

class PNCreateNotebookOperation: Procedure, InputProcedure {
    private var realm: Realm
    private var notebookName: String
    internal var input: Pending<Note> = .pending
    
    public required init(notebookName: String, realm: Realm) {
        self.notebookName = notebookName
        self.realm = realm
        
        super.init()
    }
    
    public override func execute() {
        let notebook = Notebook()
        notebook.notebookId = "\(Date().timeStampFromDate())"
        notebook.name = notebookName
        notebook.dateCreated = Date()
        
        weak var weakSelf = self
        DispatchQueue.main.async {
            guard let strongSelf = weakSelf else {
                print("Weak self is nil")
                return
            }
            
            do {
                try strongSelf.realm.write {
                    strongSelf.realm.add(notebook)
                }
            } catch { }
        }
    }
}
