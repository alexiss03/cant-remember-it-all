//
//  EditNoteQuickSpec.swift
//  Memo
//
//  Created by Hanet on 6/21/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Quick
import Nimble

import UIKit
import RealmSwift

@testable import Memo

class EditNoteQuickSpec: QuickSpec {
    override func spec() {
        var vc: PNCreateNoteViewController?
        var realm: Realm?
        
        beforeEach {
            vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PNCreateNoteViewController") as? PNCreateNoteViewController
            realm = PNSharedRealm.configureDefaultRealm()
        }
        
        describe("edit note") {
            it("with empty content") {
                guard let unwrappedRealm = realm else { return }
    
                let note = createNoteInstance()
                add(realm: unwrappedRealm, note: note)
                
                let oldCount = unwrappedRealm.objects(Note.self).count
                
                loadController(note: note)
                updateNotes(notes: "")
                
                let predicate = NSPredicate.init(format: "noteId == %@", note.noteId!)
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCount), timeout: 0.1)
                expect(unwrappedRealm.objects(Note.self).filter(predicate).first?.title).toEventually(equal("This is a note"), timeout: 0.1)
                
            }
            it("without a notebook") {
                guard let unwrappedRealm = realm else { return }

                let note = createNoteInstance()
                add(realm: unwrappedRealm, note: note)
                
                let oldCount = unwrappedRealm.objects(Note.self).count
                
                loadController(note: note)
                updateNotes(notes: "This is an updated note")
            
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCount), timeout: 0.1)
                
            }
            
            it("with a notebook") {
                guard let unwrappedRealm = realm else { return }
                
                let notebook = createNotebookInstance()
                let note = createNoteInstance(notebook: notebook)
                
                add(realm: unwrappedRealm, note: note, notebook: notebook)
                loadController(note: note, notebook: notebook)
                
                let oldCountAllNotes = unwrappedRealm.objects(Note.self).count
                let predicate = NSPredicate.init(format: "notebook == %@", notebook)
                let oldCountNotesForNotebook = unwrappedRealm.objects(Note.self).filter(predicate).count
                
                updateNotes(notes: "This is a note")
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCountAllNotes), timeout: 0.1)
                expect(unwrappedRealm.objects(Note.self).filter(predicate).count).toEventually(equal(oldCountNotesForNotebook), timeout: 0.1)
                
            }
        }
        
        func createNoteInstance(notebook: Notebook? = nil) -> Note {
            let note = Note()
            note.noteId = "\(Date().timeStampFromDate())"
            note.body = "This is a note"
            note.title = "This is a note"
            note.notebook = notebook
            
            return note
        }
        
        func createNotebookInstance() -> Notebook {
            let notebook = Notebook()
            notebook.notebookId = "\(Date().timeStampFromDate())"
            return notebook
        }
        
        func updateNotes(notes: String) {
            vc?.baseView?.contentTextView.text = notes
            vc?.viewWillDisappear(true)
        }
        
        func loadController(note: Note? = nil, notebook: Notebook? = nil) {
            vc?.note = note
            vc?.notebook = notebook
            vc?.loadViewProgrammatically()
        }
        
        func add(realm: Realm, note: Note? = nil, notebook: Notebook? = nil) {
            do {
                try realm.write {
                    if let unwrappedNotebook = notebook {
                        realm.add(unwrappedNotebook)
                    }
                    
                    if let unwrappedNote = note {
                        realm.add(unwrappedNote)
                    }
                }
            } catch { }
        }
    }
    
  }
