//
//  PNMoveNoteInteractor.swift
//  Memo
//
//  Created by Hanet on 6/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import RealmSwift

/**
 The `PNMoveNoteInteractor` class contains the business logic of the Move Note module
 */
struct PNMoveNoteInteractor {
    /// A `Realm` instance where the note is to be moved.
    private var realm: Realm
    
    /**
     Initializes the instance.
     
     - Parameter realm: A `Realm` instance where the note is to be moved.
     */
    init(realm: Realm) {
        self.realm = realm
    }
    
    /**
     Moves the note to the a notebook.
     
     - Parameter note: A `Note` instance to be moved.
     - Parameter position: Position of the notebook in the list where the note is to be moved to.
    */
    internal func move(note: Note, position: Int) {
        let notebookList = realm.objects(Notebook.self).sorted(byKeyPath: "dateCreated", ascending: true)
        
        do {
            try? realm.write {
                note.notebook = notebookList[position]
                note.dateUpdated = Date()
            }
        }
    }
}
