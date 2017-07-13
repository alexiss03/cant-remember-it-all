//
//  SearchNoteQuickSpec.swift
//  Memo
//
//  Created by Hanet on 7/4/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Quick
import Nimble

import UIKit
import RealmSwift

@testable import Memo

class SearchNoteQuickSpec: QuickSpec, NoteQuickSpecProtocol {
    var controller: UIViewController?
    
    override func spec() {
        var realm: Realm?
        var viewController: PNNotesFeedViewController? {
            didSet {
                self.controller = viewController
            }
        }
        
        beforeEach {
            viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PNNotesFeedViewController") as? PNNotesFeedViewController
            realm = PNSharedRealm.realmInstance()
        }
        
        describe("search") {
            it("with body") {
                guard let unwrappedRealm = realm else {
                    print("Realm is nil")
                    return
                }
                
                var notesList: [Note] = []
                
                for _ in 0 ..< 5 {
                    let note =  self.note()
                    note.body = "This is a note title for search."
                    notesList.append(note)
                    self.add(realm: unwrappedRealm, note: note, notebook: nil)
                }
                
                let oldCountAllNotes = unwrappedRealm.objects(Note.self).filter(NSPredicate.init(format: "body LIKE 'This is a note title for search.'")).count
                
                viewController?.currentNotebook = nil
                viewController?.loadViewProgrammatically()
                
                expect(viewController?.baseView?.notesListTableView.numberOfRows(inSection: 0)).toEventually(equal(oldCountAllNotes))
            }
        }
    }
}
