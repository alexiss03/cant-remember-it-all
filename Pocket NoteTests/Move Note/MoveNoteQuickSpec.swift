//
//  MoveNoteQuickSpec.swift
//  Memo
//
//  Created by Hanet on 7/3/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Quick
import Nimble

import UIKit
import RealmSwift

@testable import Memo

class MoveNoteQuickSpec: QuickSpec, NoteQuickSpecProtocol {
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
        
        it("move note") {
            guard let unwrappedRealm = realm else {
                print("Realm is nil")
                return
            }
            
            let note = self.note()
            let oldNotebook = self.notebook()
            let newNotebook = self.notebook()
            self.add(realm: unwrappedRealm, note: note, withNotebook: oldNotebook)
            self.add(realm: unwrappedRealm, notebook: newNotebook)
            
            UIApplication.shared.keyWindow?.rootViewController = viewController
            viewController?.openMoveNoteToANotebook(note: note)
            
            let moveNotebook = viewController?.presentedViewController as? PNMoveNoteViewController
            
            if let unwrappedTableView = moveNotebook?.baseView?.tableView {
                moveNotebook?.tableView(unwrappedTableView, didSelectRowAt: IndexPath.init(row: 1, section: 0))
            }

            expect(note.notebook).toNotEventually(equal(oldNotebook))
        }
    }
}
