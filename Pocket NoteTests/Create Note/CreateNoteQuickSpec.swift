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
    var controller: UIViewController? {get set}
    
    func notebook() -> Notebook
    func note(notebook: Notebook?, body: String?) -> Note
    func add(realm: Realm, note: Note?, notebook: Notebook?)
}

extension NoteQuickSpecProtocol {
    func notebook() -> Notebook {
        let notebook = Notebook()
        notebook.notebookId = "\(Date().timeStampFromDate())"
        notebook.dateCreated = Date()
        notebook.name = "Notebook"
        return notebook
    }
    
    func note(notebook: Notebook? = nil, body: String? = nil) -> Note {
        let note = Note()
        note.noteId = "\(Date().timeStampFromDate())"
        
        if let unwrappedBody = body {
            note.body = unwrappedBody
        } else {
            note.body = "This is a note"
        }
        
        note.title = "This is a note"
        note.notebook = notebook
        note.dateCreated = Date()

        return note
    }
    
    func add(realm: Realm, note: Note? = nil) {
        do {
            try realm.write {
                if let unwrappedNote = note {
                    realm.add(unwrappedNote)
                }
            }
        } catch { }
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
    
    func add(realm: Realm, note: Note? = nil, withNotebook notebook: Notebook? = nil) {
        do {
            try realm.write {
                if let unwrappedNotebook = notebook {
                    realm.add(unwrappedNotebook)
                }
                
                if let unwrappedNote = note {
                    unwrappedNote.notebook = notebook
                    realm.add(unwrappedNote)
                }
            }
        } catch { }
    }
}

class CreateNoteQuickSpec: QuickSpec, NoteQuickSpecProtocol {
    var controller: UIViewController?
    
    class MockPNCreateNoteViewController: PNCreateNoteViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            view = Bundle.main.loadNibNamed("PNCreateNoteView", owner: self, options: nil)![0] as? PNCreateNoteView
        }

        internal func set(notebook: Notebook?) {
            self.notebook = notebook
        }
        
        internal func viewWillDisappear(content: String) {
            baseView?.setContentTextView(content: content)
            super.viewWillDisappear(true)
        }
    }
     
    override func spec() {
        var viewController = MockPNCreateNoteViewController()
        var realm: Realm?

        beforeEach {
            viewController = MockPNCreateNoteViewController()
            realm = PNSharedRealm.configureDefaultRealm()
        }
        
        describe("create new note") {
            it("with wrong input") {
                guard let unwrappedRealm = realm else { return }
                
                viewController.loadViewProgrammatically()
                let oldCount = unwrappedRealm.objects(Note.self).count
                
                viewController.viewWillDisappear(true)

                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCount))
            }
            
            it("without a notebook") {
                guard let unwrappedRealm = realm else { return }
                
                viewController.loadViewProgrammatically()
                let oldCount = unwrappedRealm.objects(Note.self).count
                viewController.viewWillDisappear(content: "This is a note.")
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCount+1))
            }
            
            it("with a notebook") {
                guard let unwrappedRealm = realm else { return }

                let notebook = self.notebook()
                self.add(realm: unwrappedRealm, notebook: notebook)
                
                let oldCountAllNotes = unwrappedRealm.objects(Note.self).count
                let predicate = NSPredicate.init(format: "notebook == %@", notebook)
                let oldCountNotesForNotebook = unwrappedRealm.objects(Note.self).filter(predicate).count
                
                viewController.set(notebook: notebook)
                viewController.loadViewProgrammatically()
                
                viewController.viewWillDisappear(content: "This is a note")
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCountAllNotes+1))
                expect(unwrappedRealm.objects(Note.self).filter(predicate).count).toEventually(equal(oldCountNotesForNotebook+1))
            }
        }
        
    }
}
