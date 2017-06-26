//
//  DeleteNotebookOperation.swift
//  Memo
//
//  Created by Hanet on 6/26/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import ProcedureKit
import RealmSwift

class PNDeleteNotebookOperation: Procedure {
    private var realm: Realm
    private var notebook: Notebook
    
    public required init(notebook: Notebook, realm: Realm) {
        self.notebook = notebook
        self.realm = realm
        
        super.init()
    }
    
    public override func execute() {
        weak var weakSelf = self
        DispatchQueue.main.async {
            guard let strongSelf = weakSelf else {
                print("Weak self is nil")
                return
            }
            
            do {
                try strongSelf.realm.write {
                    strongSelf.realm.delete(strongSelf.notebook.notes)
                    strongSelf.realm.delete(strongSelf.notebook)
                    self.finish()
                }
            } catch { }
        }
    }
}
