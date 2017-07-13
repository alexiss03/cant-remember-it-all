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
    var controller: UIViewController?
    
    class MockPNCreateNoteViewController: PNCreateNoteViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            view = Bundle.main.loadNibNamed("PNCreateNoteView", owner: self, options: nil)![0] as? PNCreateNoteView
        }
        
        func set(note: Note?) {
            self.note = note
        }
    }
    
    override func spec() {
        var viewController = MockPNCreateNoteViewController()
        
        beforeEach {
            viewController = MockPNCreateNoteViewController()
        }
        
        describe("view a note") {
            it("with body") {
                let note = self.note()
                viewController.set(note: note)
                viewController.loadViewProgrammatically()
                expect(viewController.baseView?.getContentText()).toEventually(equal(note.body))
            }
            
            it("with empty string body") {
                let note = self.note(body: "")
                viewController.set(note: note)
                viewController.loadViewProgrammatically()
                expect(viewController.baseView?.getContentText()).toEventually(equal(""))
            }
        }
    }
}
