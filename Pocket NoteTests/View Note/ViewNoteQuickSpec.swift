//
//  ViewNoteQuickSpec.swift
//  Memo
//
//  Created by Hanet on 6/23/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Quick
import Nimble

import UIKit
import RealmSwift

@testable import Memo

class ViewNoteQuickSpec: QuickSpec, NoteQuickSpecProtocol {
    var controllerType: UIViewControllerType?
    
    override func spec() {
        var realm: Realm?
        var viewController: PNCreateNoteViewController? {
            didSet {
                self.controllerType = viewController
            }
        }
        
        beforeEach {
            viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PNCreateNoteViewController") as? PNCreateNoteViewController
            realm = PNSharedRealm.configureDefaultRealm()
        }
        
        describe("view a note") {
            it("with body") {
                let note = self.noteInstance()
                self.loadController(note: note)
                
                expect(viewController?.baseView?.contentTextView.text).toEventually(equal(note.body))
            }
            
            it("with empty string body") {
                let note = self.noteInstance(body: "")
                self.loadController(note: note)
                
                expect(viewController?.baseView?.contentTextView.text).toEventually(equal(""))
            }
        }

    }
}
