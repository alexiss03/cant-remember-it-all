//
//  NotebookModelTestCase.swift
//  Pocket Note
//
//  Created by Hanet on 4/11/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Pocket_Note

class NotebookModelTestCase: XCTestCase {
    
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
    
    func testAddNotebook() {
        guard let unwrappedRealm = realm else { return }
        
        let notebook = Notebook()
        notebook.name = "This is a notebook name."
        notebook.dateCreated = Date()
        notebook.notebookId = "NOTEBOOK01"
        
        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(notebook)
            }
        } catch { }
        
        let newNotebook = unwrappedRealm.objects(Notebook.self).filter("notebookId = 'NOTEBOOK01'").first
        
        XCTAssertEqual(newNotebook?.notebookId, "NOTEBOOK01")
    }

    func testUpdateNotebookName() {
        guard let unwrappedRealm = realm else { return }
        
        let notebook = Notebook()
        notebook.name = "This is a notebook name."
        notebook.dateCreated = Date()
        notebook.notebookId = "NOTEBOOK01"
        
        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(notebook)
            }
        } catch { }

        do {
            try unwrappedRealm.write {
                let values = ["notebookId": "NOTEBOOK01", "name": "This is an updated notebook name."]
                _ = unwrappedRealm.create(Notebook.self, value: values, update: true)
            }
        } catch { }
        
        let updatedNotebook = unwrappedRealm.objects(Notebook.self).filter("notebookId = 'NOTEBOOK01'").first
        XCTAssertEqual(updatedNotebook?.name, "This is an updated notebook name.")
    }
    
    func testDeleteNotebook() {
        guard let unwrappedRealm = realm else { return }
        
        let note1 = Note()
        note1.noteId = "NOTE01"
        note1.body = "This is a body."
        note1.title = "This is a title."
        note1.dateCreated = Date()
        
        let note2 = Note()
        note2.noteId = "NOTE02"
        note2.body = "This is a body."
        note2.title = "This is a title."
        note2.dateCreated = Date()
        
        let notebook = Notebook()
        notebook.name = "This is a notebook name."
        notebook.dateCreated = Date()
        notebook.notebookId = "NOTEBOOK01"
        notebook.notes?.append(note1)
        notebook.notes?.append(note2)
        
        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(note1)
                unwrappedRealm.add(note2)
                unwrappedRealm.add(notebook)
            }
        } catch { }
        
        do {
            try unwrappedRealm.write {
                _ = unwrappedRealm.delete(notebook)
            }
        } catch { }
        
        let deletedNotebook = unwrappedRealm.objects(Notebook.self).filter("notebookId = 'NOTEBOOK01'").first
        let updatedNote1 = unwrappedRealm.objects(Note.self).filter("noteId = 'NOTE01'")
        let updatedNote2 = unwrappedRealm.objects(Note.self).filter("noteId = 'NOTE02'")
        
        XCTAssertNil(deletedNotebook)
        XCTAssertEqual(updatedNote1.count, 1)
        XCTAssertEqual(updatedNote2.count, 1)
    }
    
}
