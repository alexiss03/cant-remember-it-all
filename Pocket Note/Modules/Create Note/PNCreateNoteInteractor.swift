//
//  PNCreateNoteInteractor.swift
//  Memo
//
//  Created by Hanet on 6/19/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import RealmSwift

/**
 The `PNCreateNoteInteractor` struct holds the business logic for creating a new note. It uses `PNNewNoteContentCondition` and `PNCreateNoteOperation` for the main execution.
 */
struct PNCreateNoteInteractor {
    /// A `Realm` that is where a note is to be created or updated.
    private var realm: Realm
    
    /**
     Initializes an instance of `PNCreateNoteInteractor`.
     
     - Parameter realm: A `Realm` that is where a note is to be created or updated.
     */
    public  init(realm: Realm) {
        self.realm = realm
    }
    
    /**
     Creates the note instance, and adds it to the `Realm`;
     
     - Parameter content: The new content of the note to be created to be updated
     - Parameter note: A `Note` instance that is to be updated.
     - Parameter notebook: A `Notebook` instance that is to be container of the note to be created or to be updated.
     */
    public func createNote(content: String, note: Note?, notebook: Notebook?) {
        let newNoteValidationCondition = PNNewNoteContentCondition.init(content: content)
        let createNoteOperation = PNCreateNoteOperation.init(note: note, notebook: notebook, text: content, realm: realm)
        createNoteOperation.addCondition(newNoteValidationCondition)
        PNOperationQueue.networkOperationQueue.addOperation(createNoteOperation)
    }
}
