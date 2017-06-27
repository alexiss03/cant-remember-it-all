//
//  DeleteNoteQuickSpec.swift
//  Memo
//
//  Created by Hanet on 6/22/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Quick
import Nimble

import UIKit
import RealmSwift

@testable import Memo

class DeleteNoteQuickSpec: QuickSpec, NoteQuickSpecProtocol {
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
            realm = PNSharedRealm.configureDefaultRealm()
        }
        
        it("delete a note") {
            guard let unwrappedRealm = realm else {
                print("Realm is nil")
                return
            }
            let note = self.noteInstance()
            self.add(realm: unwrappedRealm, note: note)
            
            let oldCountAllNotes = unwrappedRealm.objects(Note.self).count
            
            viewController?.loadViewProgrammatically()
            viewController?.deleteNoteInteractor?.deleteSelectedNote(indexPath: IndexPath.init(row: 0, section: 0), filter: nil, realm: unwrappedRealm)
            
            expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCountAllNotes-1))
        }
        
        it("delete two notes") {
            guard let unwrappedRealm = realm else {
                print("Realm is nil")
                return
            }
            let note = self.noteInstance()
            let secondNote = self.noteInstance()
            self.add(realm: unwrappedRealm, note: note)
            self.add(realm: unwrappedRealm, note: secondNote)
            
            let oldCountAllNotes = unwrappedRealm.objects(Note.self).count
            
            viewController?.loadViewProgrammatically()
            viewController?.deleteNoteInteractor?.deleteSelectedNote(indexPath: IndexPath.init(row: 0, section: 0), filter: nil, realm: unwrappedRealm)
            viewController?.deleteNoteInteractor?.deleteSelectedNote(indexPath: IndexPath.init(row: 1, section: 0), filter: nil, realm: unwrappedRealm)
            
            expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCountAllNotes-2))
        }

    }
}
