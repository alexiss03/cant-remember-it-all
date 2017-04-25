//
//  NoteModelTestCase.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 4/11/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import Quick
import Nimble

@testable import Pocket_Note

import RealmSwift

class NoteModelQuickSpec: QuickSpec {
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
        
        describe("operation on a Note") {
            describe("addition") {
                it("without a Notebook") {
                    guard let unwrappedRealm = self.realm else { return }
                    
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
                    expect(newNote).notTo(equal(nil))
                }
                
                it("with a Notebook") {
                    guard let unwrappedRealm = self.realm else { return }
                    
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
                    
                    expect(newNote).notTo(equal(nil))

                }
            }
            
            describe("updating") {
                it("body") {
                    guard let unwrappedRealm = self.realm else { return }
                    
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
                    expect(updatedNote?.body).to(equal("This is an updated note body."))
                }
                
                it("title") {
                    guard let unwrappedRealm = self.realm else { return }
                    
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
                    expect(updatedNote?.title).to(equal("This is an updated note title."))
                }

            }
            
            describe("moving from a Notebook") {
                it("to another Notebook") {
                    guard let unwrappedRealm = self.realm else { return }
                    
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
                    expect(updatedNote.first?.notebook?.notebookId).to(equal("NOTEBOOK02"))
                }
            }
            
            describe("deletion") {
                it("not in a Notebook") {
                    guard let unwrappedRealm = self.realm else { return }
                    
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
                    expect(deletedNote).to(beNil())
                }
                
                it("in a Notebook") {
                    guard let unwrappedRealm = self.realm else { return }
                    
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
                    
                    expect(deletedNote).to(beNil())
                    expect(updatedNotebook.count).to(equal(1))
                }
            }
        }
        
    }
}
