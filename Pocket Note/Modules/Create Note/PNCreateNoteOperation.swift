//
//  PNCreationNoteOperation.swift
//  Memo
//
//  Created by Hanet on 6/19/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import PSOperations
import RealmSwift

/**
 The `PNCreateNoteOperation` class adds a new note or updates the content of a note in a specified realm.
 */
class PNCreateNoteOperation: PSOperation {
    /// A `Note` instance to updated.
    private var note: Note?
    /// A `Notebook` instance that will be the notebook of the newly created note or already the notebook of the note to be updated.
    private var notebook: Notebook?
    /// A `Realm` instance where the new note is to be added.
    private var realm: Realm
    /// A `String` value containing the new note of the note to be created or updated.
    private var text: String?
    
    /**
     Initializes the instance.
     
     - Parameter note: A `Note` instance to updated.
     - Parameter notebook: A `Notebook` instance that will be the notebook of the newly created note or already the notebook of the note to be updated.
     - Parameter text: A `String` value containing the new note of the note to be created or updated.
     - Parameter realm: A `Realm` instance where the new note is to be added.
    */
    required init(note: Note?, notebook: Notebook?, text: String?, realm: Realm) {
        self.note = note
        self.notebook = notebook
        self.text = text
        self.realm = realm
        super.init()
    }
    
    /**
     Executes the logic of this operation.
     
     This updates an existing note or creates a new note in a notebook.
     */
    override func execute() {
        guard let unwrappedText = text, unwrappedText.characters.count > 0 else {
            return
        }
        
        if note != nil {
            updateNote(text: unwrappedText)
        } else {
            createNewNoteInstance(text: unwrappedText)
        }
    }
    
    /**
     Creates a new note instance given a text,
     
     - Parameter text: A `String` value representing the content of the new notebook.
     */
    private func createNewNoteInstance(text: String) {
        let note = Note()
        note.noteId = "\(Date().timeStampFromDate())"
        note.body = text
        note.title = text
        note.dateCreated = Date()
        note.dateUpdated = Date()
        note.notebook = notebook
        
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    self.realm.add(note)
                }
            } catch { }
        }
    }
    
    /**
     Updates the content note of an existing note.
     
     - Parameter text: A `String` value of the new content of the existing note.
     */
    private func updateNote(text: String) {
        guard let unwrappedNote = note else {
            print("Note is nil")
            return
        }
        
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    if unwrappedNote.body != text {
                        unwrappedNote.body = text
                        unwrappedNote.dateUpdated = Date()
                    }
                }
            } catch { }
        }
    }
}
