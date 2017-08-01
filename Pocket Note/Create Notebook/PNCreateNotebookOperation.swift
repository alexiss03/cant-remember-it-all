//
//  PNCreateNotebookOperation.swift
//  Memo
//
//  Created by Hanet on 6/23/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import ProcedureKit
import RealmSwift

/**
 This is the class responsible for creating new `Notebook` into a `Realm`
 */
final class PNCreateNotebookOperation: Procedure {
    /// This is the realm where the new `Notebook` is to be created
    private var realm: Realm
    /// This is the name of the new `Notebook`
    private var notebookName: String

    /**
     This is the required initialization method. 
     - Parameter notebookName: The name of the `Notebook` to be created.
     - Paramter realm: The `Realm` where the new `Notebook` is to be added.
     */
    public required init(notebookName: String, realm: Realm) {
        self.notebookName = notebookName
        self.realm = realm
        
        super.init()
    }
    
    /**
     This is the execution method of this `Operation`. This instantiates a new `Notebook` instance.
     After that, inserts that instance to the realm.
     */
    public override func execute() {
        let notebook = Notebook()
        let uuid = UUID().uuidString
        notebook.notebookId  = "\(uuid)\(Date().timeStampFromDate())"
        notebook.name = notebookName
        notebook.dateCreated = Date()
        notebook.dateUpdated = Date()
        
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
