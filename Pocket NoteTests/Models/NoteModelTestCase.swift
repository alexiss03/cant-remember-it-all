//
//  NoteModelTestCase.swift
//  Pocket Note
//
//  Created by Hanet on 4/11/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import XCTest
import RealmSwift

@testable import Pocket_Note

class NoteModelTestCase: XCTestCase {
    
    var realm: Realm?
    
    override func setUp() {
        do {
            realm = try Realm()
            
            guard let unwrappedRealm = realm else { return }
            try unwrappedRealm.write {
                realm?.deleteAll()
            }
        } catch { }
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddNoteWithoutNotebook() {
        guard let unwrappedRealm = realm else { return }
        
        let note = Note()
        note.noteId = "NOTE01"
        note.body = "This is a body."
        note.title = "This is a title."
        note.dateCreated = Date()

        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(note)
            }
        } catch { }
        
        let newNote = unwrappedRealm.objects(Note.self).filter("noteId = 'NOTE01'").first
        XCTAssertNotNil(newNote)
    }
    
    func testAddNoteWithNotebook() {
        guard let unwrappedRealm = realm else { return }
        
        let notebook = Notebook()
        notebook.name = "This is a notebook title."
        notebook.dateCreated = Date()
        notebook.notebookId = "NOTEBOOK01"
        
        let note = Note()
        note.noteId = "NOTE01"
        note.body = "This is a body."
        note.title = "This is a title."
        note.dateCreated = Date()
        note.notebook = notebook
        
        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(note)
            }
        } catch { }
        
        let newNote = unwrappedRealm.objects(Note.self).filter("noteId = 'NOTE01'").first
    
        XCTAssertEqual(newNote?.notebook?.notebookId, "NOTEBOOK01")
    }
    
    func testUpdateNoteBody() {
        guard let unwrappedRealm = realm else { return }
        
        let note = Note()
        note.noteId = "NOTE01"
        note.body = "This is a body."
        note.title = "This is a title."
        note.dateCreated = Date()
        
        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(note)
            }
        } catch { }
        
        do {
            try unwrappedRealm.write {
                let values = ["noteId": "NOTE01", "body": "This is an updated note body."]
                _ = unwrappedRealm.create(Note.self, value: values, update: true)
            }
        } catch { }
        
        let updatedNote = unwrappedRealm.objects(Note.self).filter("noteId = 'NOTE01'").first
        XCTAssertEqual(updatedNote?.body, "This is an updated note body.")
        
    }

    func testUpdateNotNoteBody() {
        guard let unwrappedRealm = realm else { return }
        
        let note = Note()
        note.noteId = "NOTE01"
        note.body = "This is a body."
        note.title = "This is a title."
        note.dateCreated = Date()
        
        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(note)
            }
        } catch { }
        
        do {
            try unwrappedRealm.write {
                _ = unwrappedRealm.create(Note.self, value: ["noteId": "NOTE01"], update: true)
            }
        } catch { }
        
        let updatedNote = unwrappedRealm.objects(Note.self).filter("noteId = 'NOTE01'").first
        XCTAssertEqual(updatedNote?.body, "This is a body.")
        
    }

    func testUpdateNoteTitle() {
        guard let unwrappedRealm = realm else { return }
        
        let note = Note()
        note.noteId = "NOTE01"
        note.body = "This is a body."
        note.title = "This is a title."
        note.dateCreated = Date()
        
        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(note)
            }
        } catch { }
        
        do {
            try unwrappedRealm.write {
                let values = ["noteId": "NOTE01", "title": "This is an updated note title."]
                _ = unwrappedRealm.create(Note.self, value: values, update: true)
            }
        } catch { }
        
        let updatedNote = unwrappedRealm.objects(Note.self).filter("noteId = 'NOTE01'").first
        XCTAssertEqual(updatedNote?.title, "This is an updated note title.")
        
    }
    
    func testUpdateNotNoteTitle() {
        guard let unwrappedRealm = realm else { return }
        
        let note = Note()
        note.noteId = "NOTE01"
        note.body = "This is a body."
        note.title = "This is a title."
        note.dateCreated = Date()
        
        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(note)
            }
        } catch { }
        
        do {
            try unwrappedRealm.write {
                _ = unwrappedRealm.create(Note.self, value: ["noteId": "NOTE01"], update: true)
            }
        } catch { }
        
        let updatedNote = unwrappedRealm.objects(Note.self).filter("noteId = 'NOTE01'")
        XCTAssertEqual(updatedNote.first?.title, "This is a title.")
        
    }
    
    func testMoveNoteToAnotherNotebook() {
        guard let unwrappedRealm = realm else { return }
        
        let notebook = Notebook()
        notebook.name = "This is a notebook title."
        notebook.dateCreated = Date()
        notebook.notebookId = "NOTEBOOK01"
        
        let note = Note()
        note.noteId = "NOTE01"
        note.body = "This is a body."
        note.title = "This is a title."
        note.dateCreated = Date()
        note.notebook = notebook
        
        let notebook2 = Notebook()
        notebook2.name = "This is a notebook title."
        notebook2.dateCreated = Date()
        notebook2.notebookId = "NOTEBOOK02"
        
        do {
            try unwrappedRealm.write {
                let values = ["noteId": "NOTE01", "notebook": notebook2] as [String : Any]
                _ = unwrappedRealm.create(Note.self, value: values, update: true)
            }
        } catch { }
        
        let updatedNote = unwrappedRealm.objects(Note.self).filter("noteId = 'NOTE01'")
        XCTAssertEqual(updatedNote.first?.notebook?.notebookId, "NOTEBOOK02")
    }
    
    func testDeleteNoteWithoutNotebook() {
        guard let unwrappedRealm = realm else { return }
        
        let note = Note()
        note.noteId = "NOTE01"
        note.body = "This is a body."
        note.title = "This is a title."
        note.dateCreated = Date()
        
        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(note)
            }
        } catch { }
        
        do {
            try unwrappedRealm.write {
                _ = unwrappedRealm.delete(note)
            }
        } catch { }
        
        let deletedNote = unwrappedRealm.objects(Note.self).filter("noteId = 'NOTE01'").first
        XCTAssertNil(deletedNote)
    }
    
    func testDeleteNoteWithNotebook() {
        guard let unwrappedRealm = realm else { return }
        
        let notebook = Notebook()
        notebook.name = "This is a notebook title."
        notebook.dateCreated = Date()
        notebook.notebookId = "NOTEBOOK01"
        
        let note = Note()
        note.noteId = "NOTE01"
        note.body = "This is a body."
        note.title = "This is a title."
        note.dateCreated = Date()
        note.notebook = notebook
        
        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(note)
            }
        } catch { }
        
        do {
            try unwrappedRealm.write {
                _ = unwrappedRealm.delete(note)
            }
        } catch { }
        
        let deletedNote = unwrappedRealm.objects(Note.self).filter("noteId = 'NOTE01'").first
        let updatedNotebook = unwrappedRealm.objects(Notebook.self).filter("notebookId = 'NOTEBOOK01'")
        
        XCTAssertNil(deletedNote)
        XCTAssertEqual(updatedNotebook.count, 1)
    }
}
