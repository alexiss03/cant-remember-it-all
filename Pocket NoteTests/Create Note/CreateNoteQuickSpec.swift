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

class CreateNoteQuickSpec: QuickSpec {
    override func spec() {
        var vc: PNCreateNoteViewController?
        var realm: Realm?
        
        beforeEach {
            vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PNCreateNoteViewController") as? PNCreateNoteViewController
            realm = PNSharedRealm.configureDefaultRealm()
        }
        
        describe("create new note") {
            it("with wrong input") {
                guard let unwrappedRealm = realm else { return }
                
                vc?.loadViewProgrammatically()
                let oldCount = unwrappedRealm.objects(Note.self).count
                
                vc?.viewWillDisappear(true)
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCount), timeout: 0.1)
            }
            
            it("without a notebook") {
                guard let unwrappedRealm = realm else { return }
                
                vc?.loadViewProgrammatically()
                let oldCount = unwrappedRealm.objects(Note.self).count
                
                vc?.baseView?.contentTextView.text = "This is a note"
                vc?.viewWillDisappear(true)
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCount+1), timeout: 0.1)
                
            }
            
            it("with a notebook") {
                guard let unwrappedRealm = realm else { return }

                let notebook = Notebook()

                do {
                    try unwrappedRealm.write {
                        unwrappedRealm.add(notebook)
                    }
                } catch { }
                
                let oldCountAllNotes = unwrappedRealm.objects(Note.self).count
                let predicate = NSPredicate.init(format: "notebook == %@", notebook)
                let oldCountNotesForNotebook = unwrappedRealm.objects(Note.self).filter(predicate).count
                
                vc?.notebook = notebook
                vc?.loadViewProgrammatically()
                
                vc?.baseView?.contentTextView.text = "This is a note"
                vc?.viewWillDisappear(true)
                
                expect(unwrappedRealm.objects(Note.self).count).toEventually(equal(oldCountAllNotes+1), timeout: 0.1)
                expect(unwrappedRealm.objects(Note.self).filter(predicate).count).toEventually(equal(oldCountNotesForNotebook+1), timeout: 0.1)

            }
        }
        
    }
}
