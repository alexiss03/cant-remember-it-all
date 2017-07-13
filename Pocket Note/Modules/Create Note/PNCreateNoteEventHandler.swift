//
//  PNCreateNoteEventHandler.swift
//  Memo
//
//  Created by Hanet on 7/13/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

protocol PNCreateNoteVIPEREventHandler: VIPEREventHandler {
    func saveNote(content: String?)
}

class PNCreateNoteEventHandler: PNCreateNoteVIPEREventHandler {
    private var note: Note?
    private var notebook: Notebook?
    private var realm: Realm
    
    init(note: Note?, notebook: Notebook?, realm: Realm) {
        self.note = note
        self.notebook = notebook
        self.realm = realm
    }
    
    public func saveNote(content: String?) {
        let createNoteInputInteractor = PNCreateNoteInputInteractor.init(content: content, note: note)
        let createNoteInteractor = PNCreateNoteInteractor.init(note: note, notebook: notebook, realm: realm)
        createNoteInteractor.injectResult(from: createNoteInputInteractor)
        PNOperationQueue.realmOperationQueue.add(operations: [createNoteInputInteractor, createNoteInteractor])
    }
}
