//
//  PNCreateNoteInteractor.swift
//  Memo
//
//  Created by Hanet on 6/19/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import RealmSwift

struct PNCreateNoteInteractor {
    var note: Note?
    var notebook: Notebook?
    var realm: Realm?
    
    init(note: Note?, notebook: Notebook?, realm: Realm) {
        self.note = note
        self.notebook = notebook
        self.realm = realm
    }
    
    func createNote(content: String?) {
        let newNoteValidationCondition = PNNewNoteContentCondition.init(content: content)
        let createNoteOperation = PNCreateNoteOperation.init(note: note, notebook: notebook, text: content, realm: realm)
        createNoteOperation.addCondition(newNoteValidationCondition)
        PNOperationQueue.networkOperationQueue.addOperation(createNoteOperation)
    }
}
