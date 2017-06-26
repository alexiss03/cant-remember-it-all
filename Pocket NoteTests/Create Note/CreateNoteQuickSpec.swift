//
//  CreateNoteQuickSpec.swift
//  Memo
//
//  Created by Hanet on 6/19/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Quick
import Nimble

import UIKit
import RealmSwift

@testable import Memo

protocol NoteQuickSpecProtocol {
    var controllerType: UIViewControllerType? {get set}
    
    func notebookInstance() -> Notebook
    func noteInstance(notebook: Notebook?, body: String?) -> Note
    
    func updateNotes(notes: String, baseView: UIView?)
    func add(realm: Realm, note: Note?, notebook: Notebook?)
}

extension NoteQuickSpecProtocol {
    func notebookInstance() -> Notebook {
        let notebook = Notebook()
        notebook.notebookId = "\(Date().timeStampFromDate())"
        return notebook
    }
    
    func noteInstance(notebook: Notebook? = nil, body: String? = nil) -> Note {
        let note = Note()
        note.noteId = "\(Date().timeStampFromDate())"
        
        if let unwrappedBody = body {
            note.body = unwrappedBody
        } else {
            note.body = "This is a note"
        }
        
        note.title = "This is a note"
        note.notebook = notebook

        return note
    }
    
    func updateNotes(notes: String, baseView: UIView?) {
        if let baseView = baseView as? ContentViewContainer {
            baseView.contentTextView.text = notes
        }
        
        if let controllerType = controllerType as? UIViewController {
            controllerType.viewWillDisappear(true)
        }
    }
    
    func loadController(note: Note? = nil, notebook: Notebook? = nil) {
        if var notebookContainter = controllerType as? NotebookContainer {
            notebookContainter.notebook = notebook
        }
        
        if var noteContainer = controllerType as? NoteContainer {
            noteContainer.note = note
        }
        
        if let controllerType = controllerType as? UIViewController {
            controllerType.loadViewProgrammatically()
        }
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

class CreateNoteQuickSpec: QuickSpec, NoteQuickSpecProtocol {
    var controllerType: UIViewControllerType?
    
    override func spec() {
        var viewController: PNCreateNoteViewController? {
            didSet {
                self.controllerType = viewController
            }
        }
        var realm: Realm?
        
        beforeEach {
            viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PNCreateNoteViewController") as? PNCreateNoteViewController
            realm = PNSharedRealm.configureDefaultRealm()
        }
        
        describe("create new note") {
            it("with wrong input") {
                guard let unwrappedRealm = realm else { return }
                
                viewController?.loadViewProgrammatically()
                let oldCount = unwrappedRealm.objects(Note.self).count
                
                viewController?.viewWillDisappear(true)
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCount), timeout: 0.1)
            }
            
            it("without a notebook") {
                guard let unwrappedRealm = realm else { return }
                
                viewController?.loadViewProgrammatically()
                let oldCount = unwrappedRealm.objects(Note.self).count
                self.updateNotes(notes: "This is a note", baseView: viewController?.baseView)
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCount+1), timeout: 0.1)
            }
            
            it("with a notebook") {
                guard let unwrappedRealm = realm else { return }

                let notebook = self.notebookInstance()
                self.add(realm: unwrappedRealm, notebook: notebook)
                
                let oldCountAllNotes = unwrappedRealm.objects(Note.self).count
                let predicate = NSPredicate.init(format: "notebook == %@", notebook)
                let oldCountNotesForNotebook = unwrappedRealm.objects(Note.self).filter(predicate).count
                
                self.loadController(notebook: notebook)
                self.updateNotes(notes: "This is a note", baseView: viewController?.baseView)
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCountAllNotes+1), timeout: 0.1)
                expect(unwrappedRealm.objects(Note.self).filter(predicate).count).toEventually(equal(oldCountNotesForNotebook+1), timeout: 0.1)
            }
        }
        
    }
}
