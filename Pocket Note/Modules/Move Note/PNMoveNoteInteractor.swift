//
//  PNMoveNoteInteractor.swift
//  Memo
//
//  Created by Hanet on 6/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import RealmSwift

protocol PNMoveNoteInteractorInterface {
    func move(note: Note, toNotebook newNotebook: Notebook)
}
/**
 The `PNMoveNoteInteractor` class contains the business logic of the Move Note module
 */
struct PNMoveNoteInteractor: PNMoveNoteInteractorInterface {
    /// A `Realm` instance where the note is to be moved.
    private var realm: Realm
    
    /**
     Initializes the instance.
     
     - Parameter realm: A `Realm` instance where the note is to be moved.
     */
    internal init(realm: Realm) {
        self.realm = realm
    }
    
    /**
     Moves the note to the a notebook.
     
     - Parameter note: A `Note` instance to be moved.
     - Parameter position: Position of the notebook in the list where the note is to be moved to.
    */
    internal func move(note: Note, toNotebook newNotebook: Notebook) {
        do {
            try? realm.write {
                note.notebook = newNotebook
                note.dateUpdated = Date()
            }
        }
    }
}
