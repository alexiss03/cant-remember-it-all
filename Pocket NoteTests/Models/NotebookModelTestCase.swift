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
        do { realm = try Realm() } catch {}
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
        notebook.id = "NOTEBOOK01"
        
        try! unwrappedRealm.write(){
            unwrappedRealm.add(notebook)
        }
        
        let newNotebook = unwrappedRealm.objects(Note.self).filter("id = 'NOTEBOOK01'").first
        
        XCTAssertEqual(newNotebook?.id, "NOTEBOOK01")
    }

    
    func testUpdateNotebookName() {
        guard let unwrappedRealm = realm else { return }
        
        let notebook = Notebook()
        notebook.name = "This is a notebook name."
        notebook.dateCreated = Date()
        notebook.id = "NOTEBOOK01"
        
        try! unwrappedRealm.write(){
            unwrappedRealm.add(notebook)
        }

        try! unwrappedRealm.write(){
            _ = unwrappedRealm.create(Notebook.self, value: ["id":"NOTEBOOK01", "name":"This is an updated notebook name."], update: true)
        }
        
        let updatedNote = unwrappedRealm.objects(Notebook.self).filter("id = 'NOTEBOOK01'").first
        XCTAssertEqual(updatedNote?.name, "This is an updated notebook name.")
    }
    
    
    func testDeleteNotebook() {
        guard let unwrappedRealm = realm else { return }
        
        let note1 = Note()
        note1.id = "NOTE01"
        note1.body = "This is a body."
        note1.title = "This is a title."
        note1.dateCreated = Date()
        
        let note2 = Note()
        note2.id = "NOTE02"
        note2.body = "This is a body."
        note2.title = "This is a title."
        note2.dateCreated = Date()
        
        let notebook = Notebook()
        notebook.name = "This is a notebook name."
        notebook.dateCreated = Date()
        notebook.id = "NOTEBOOK01"
        notebook.notes?.append(note1)
        notebook.notes?.append(note2)
        
        try! unwrappedRealm.write(){
            unwrappedRealm.add(notebook)
        }
        
        try! unwrappedRealm.write(){
            _ = unwrappedRealm.delete(notebook)
        }
        
        let deletedNotebook = unwrappedRealm.objects(Notebook.self).filter("id = 'NOTEBOOK01'").first
        let updatedNote1 = unwrappedRealm.objects(Note.self).filter("id = 'NOTEBOOK01'")
        let updatedNote2 = unwrappedRealm.objects(Note.self).filter("id = 'NOTEBOOK02'")
        
        XCTAssertNil(deletedNotebook)
        XCTAssertEqual(updatedNote1.count, 1)
        XCTAssertEqual(updatedNote2.count, 1)
    }
    
}
