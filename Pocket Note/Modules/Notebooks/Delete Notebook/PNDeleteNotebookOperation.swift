//
//  DeleteNotebookOperation.swift
//  Memo
//
//  Created by Hanet on 6/26/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import ProcedureKit
import RealmSwift

/**
 The `PNDeleteNotebookOperation` class delete a notebook and all the notes in it within an specified realm/.
*/
class PNDeleteNotebookOperation: Procedure {
    /// A `Realm` instance where the notebook and all the notebooks in it is to deleted.
    private var realm: Realm
    /// A `Notebook` instance to be deleted.
    private var notebook: Notebook
    
    /**
     Initializes the instance.
     
     - Parameter notebook: A `Notebook` instance to be deleted. 
     - Parameter realm: A `Realm` instance where the notebook and all the notebooks in it is to deleted.
     */
    public required init(notebook: Notebook, realm: Realm) {
        self.notebook = notebook
        self.realm = realm
        
        super.init()
    }
    
    /**
     Executes the logic of this operation.
     
     This where the actual deletion of a notebook and all of its' notes is deleted from a realm.
    */
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
