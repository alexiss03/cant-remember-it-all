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
                
                let note = Note()
                note.body = "This is a note"
                note.title = "This is a note"
                note.noteId = "\(Date().timeStampFromDate())"
                
                do {
                    try unwrappedRealm.write {
                        unwrappedRealm.add(note)
                    }
                } catch { }
                
                let oldCount = unwrappedRealm.objects(Note.self).count
                
                vc?.note = note
                vc?.loadViewProgrammatically()
                vc?.baseView?.contentTextView.text = ""
                vc?.viewWillDisappear(true)
                
                let predicate = NSPredicate.init(format: "noteId == %@", note.noteId!)
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCount), timeout: 0.1)
                expect(unwrappedRealm.objects(Note.self).filter(predicate).first?.title).toEventually(equal("This is a note"), timeout: 0.1)
                
            }
            it("without a notebook") {
                guard let unwrappedRealm = realm else { return }
                
                let note = Note()
                note.body = "This is a note"
                note.title = "This is a note "
                
                do {
                    try unwrappedRealm.write {
                        unwrappedRealm.add(note)
                    }
                } catch { }
                
                let oldCount = unwrappedRealm.objects(Note.self).count
                
                vc?.note = note
                vc?.loadViewProgrammatically()
                vc?.baseView?.contentTextView.text = "This is an updated note"
                vc?.viewWillDisappear(true)
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCount), timeout: 0.1)
                
            }
            
            it("with a notebook") {
                guard let unwrappedRealm = realm else { return }
                
                let notebook = Notebook()
                notebook.notebookId = "\(Date().timeStampFromDate())"
                
                let note = Note()
                note.noteId = "\(Date().timeStampFromDate())"
                note.body = "This is a note"
                note.title = "This is a note "
                note.notebook = notebook
                
                do {
                    try unwrappedRealm.write {
                        unwrappedRealm.add(notebook)
                        unwrappedRealm.add(note)
                    }
                } catch { }
                
                vc?.notebook = notebook
                vc?.note = note
                vc?.loadViewProgrammatically()
                
                let oldCountAllNotes = unwrappedRealm.objects(Note.self).count
                let predicate = NSPredicate.init(format: "notebook == %@", notebook)
                let oldCountNotesForNotebook = unwrappedRealm.objects(Note.self).filter(predicate).count
                
                vc?.baseView?.contentTextView.text = "This is a note"
                vc?.viewWillDisappear(true)
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCountAllNotes), timeout: 0.1)
                expect(unwrappedRealm.objects(Note.self).filter(predicate).count).toEventually(equal(oldCountNotesForNotebook), timeout: 0.1)
                
            }
        }
    }
}
