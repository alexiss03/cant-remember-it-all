//
//  PNCreationNoteOperation.swift
//  Memo
//
//  Created by Hanet on 6/19/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import PSOperations
import RealmSwift

class PNCreateNoteOperation: PSOperation {
    var note: Note?
    var notebook: Notebook?
    weak var realm: Realm?
    var text: String?
    
    required init(note: Note?, notebook: Notebook?, text: String?, realm: Realm?) {
        self.note = note
        self.notebook = notebook
        self.text = text
        self.realm = realm
        super.init()
    }
    
    override func execute() {
        guard let unwrappedText = text, unwrappedText.characters.count > 0, let unwrappedRealm = realm else { return }
        
        if let unwrappedNote = note {
            updateNote(text: unwrappedText, note: unwrappedNote, realm: unwrappedRealm)
        } else {
            createNewNoteInstance(text: unwrappedText, realm: unwrappedRealm)
        }
    }
    
    private func createNewNoteInstance(text: String, realm: Realm) {
        let note = Note()
        note.noteId = "\(Date().timeStampFromDate())"
        note.body = text
        note.title = "This is a title."
        note.dateCreated = Date()
        note.dateUpdated = Date()
        note.notebook = notebook
        
        DispatchQueue.main.async {
            do {
                try realm.write {
                    realm.add(note)
                }
            } catch { }
        }
    }
    
    private func updateNote(text: String, note: Note, realm: Realm) {
       DispatchQueue.main.async {
            do {
                try realm.write {
                    if note.body != text {
                        note.body = text
                        note.dateUpdated = Date()
                    }
                }
            } catch { }
        }
    }
}
