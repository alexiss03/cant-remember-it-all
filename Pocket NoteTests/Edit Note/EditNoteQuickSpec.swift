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

class EditNoteQuickSpec: QuickSpec, NoteQuickSpecProtocol {
    var controller: UIViewController?
    
    class MockPNCreateNoteViewController: PNCreateNoteViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            view = Bundle.main.loadNibNamed("PNCreateNoteView", owner: self, options: nil)![0] as? PNCreateNoteView
        }

        func set(note: Note? = nil, notebook: Notebook? = nil) {
            self.note = note
            self.notebook = notebook
        }
        
        func viewWillDisappear(content: String) {
            baseView?.setContentTextView(content: content)
            super.viewWillDisappear(true)
        }
    }
    
    override func spec() {
        var realm: Realm?
        var viewController = MockPNCreateNoteViewController()
        
        beforeEach {
            viewController = MockPNCreateNoteViewController()
            realm = PNSharedRealm.configureDefaultRealm()
        }
        
        describe("edit note") {
            it("with empty content") {
                guard let unwrappedRealm = realm else { return }
    
                let note = self.note()
                self.add(realm: unwrappedRealm, note: note, notebook: nil)
                
                let oldCount = unwrappedRealm.objects(Note.self).count
                
                viewController.set(note: note)
                viewController.loadViewProgrammatically()
                viewController.viewWillDisappear(content: "")
            
                let predicate = NSPredicate.init(format: "noteId == %@", note.noteId!)
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCount))
                expect(unwrappedRealm.objects(Note.self).filter(predicate).first?.title).toEventually(equal("This is a note"))
                
            }
            it("without a notebook") {
                guard let unwrappedRealm = realm else { return }

                let note = self.note()
                self.add(realm: unwrappedRealm, note: note, notebook: nil)
                
                let oldCount = unwrappedRealm.objects(Note.self).count
                
                viewController.set(note: note)
                viewController.loadViewProgrammatically()
                viewController.viewWillDisappear(content: "This is an updated note")
            
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCount))
            }
            
            it("with a notebook") {
                guard let unwrappedRealm = realm else { return }
                
                let notebook = self.notebook()
                let note = self.note(notebook: notebook)
                
                self.add(realm: unwrappedRealm, note: note, notebook: notebook)
                viewController.set(note: note, notebook: notebook)
                viewController.loadViewProgrammatically()
                
                let oldCountAllNotes = unwrappedRealm.objects(Note.self).count
                let predicate = NSPredicate.init(format: "notebook == %@", notebook)
                let oldCountNotesForNotebook = unwrappedRealm.objects(Note.self).filter(predicate).count
                viewController.viewWillDisappear(content: "This is a note")

                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCountAllNotes))
                expect(unwrappedRealm.objects(Note.self).filter(predicate).count).toEventually(equal(oldCountNotesForNotebook))
                
            }
        }
    }
    
  }
