//
//  NotebookModelTestCase.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 4/11/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import Quick
import Nimble

@testable import Pocket_Note

import RealmSwift

class NotebookQuickSpec: QuickSpec {
    var realm: Realm?
   
    override func spec() {
        beforeEach {
            do {
                self.realm = try Realm()
                
                guard let unwrappedRealm = self.realm else { return }
                try unwrappedRealm.write {
                    self.realm?.deleteAll()
                }
            } catch { }
        }
        
        describe("operation on Notebook") {
            it("insertion") {
                guard let unwrappedRealm = self.realm else { return }
                
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
                expect(newNotebook?.notebookId).to(equal("NOTEBOOK01"))
            }
            
            it("updating name") {
                guard let unwrappedRealm = self.realm else { return }
                
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
                
                let filter = "notebookId = 'NOTEBOOK01'"
                let updatedNotebook = unwrappedRealm.objects(Notebook.self).filter(filter).first
                expect(updatedNotebook?.name).to(equal("This is an updated notebook name."))
            }
            
            it("deletion") {
                guard let unwrappedRealm = self.realm else { return }
                
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
                
                expect(deletedNotebook).to(beNil())
                expect(updatedNote1.count).to(equal(1))
                expect(updatedNote2.count).to(equal(1))
            }
        }
    }
}

