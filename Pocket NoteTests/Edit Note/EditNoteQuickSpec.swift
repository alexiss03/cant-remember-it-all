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
    
    override func spec() {
        var realm: Realm?
        var viewController: PNCreateNoteViewController? {
            didSet {
                self.controller = viewController
            }
        }
        
        beforeEach {
            viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PNCreateNoteViewController") as? PNCreateNoteViewController
            realm = PNSharedRealm.configureDefaultRealm()
        }
        
        describe("edit note") {
            it("with empty content") {
                guard let unwrappedRealm = realm else { return }
    
                let note = self.noteInstance()
                self.add(realm: unwrappedRealm, note: note)
                
                let oldCount = unwrappedRealm.objects(Note.self).count
                
                self.loadController(note: note)
                self.updateNotes(notes: "", baseView: viewController?.baseView)
            
                let predicate = NSPredicate.init(format: "noteId == %@", note.noteId!)
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCount))
                expect(unwrappedRealm.objects(Note.self).filter(predicate).first?.title).toEventually(equal("This is a note"))
                
            }
            it("without a notebook") {
                guard let unwrappedRealm = realm else { return }

                let note = self.noteInstance()
                self.add(realm: unwrappedRealm, note: note)
                
                let oldCount = unwrappedRealm.objects(Note.self).count
                
                self.loadController(note: note)
                self.updateNotes(notes: "This is an updated note", baseView: viewController?.baseView)
            
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCount))
                
            }
            
            it("with a notebook") {
                guard let unwrappedRealm = realm else { return }
                
                let notebook = self.notebookInstance()
                let note = self.noteInstance(notebook: notebook)
                
                self.add(realm: unwrappedRealm, note: note, notebook: notebook)
                self.loadController(note: note, notebook: notebook)
                
                let oldCountAllNotes = unwrappedRealm.objects(Note.self).count
                let predicate = NSPredicate.init(format: "notebook == %@", notebook)
                let oldCountNotesForNotebook = unwrappedRealm.objects(Note.self).filter(predicate).count
                
                self.updateNotes(notes: "This is a note", baseView: viewController?.baseView)
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCountAllNotes))
                expect(unwrappedRealm.objects(Note.self).filter(predicate).count).toEventually(equal(oldCountNotesForNotebook))
                
            }
        }
    }
    
  }
