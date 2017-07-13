//
//  ViewNotesFeedQuickSpec.swift
//  Memo
//
//  Created by Hanet on 7/2/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import Quick
import Nimble

import UIKit
import RealmSwift
import SlideMenuControllerSwift

@testable import Memo

class ViewNotesFeedQuickSpec: QuickSpec, NoteQuickSpecProtocol {
    var controller: UIViewController?
    
    override func spec() {
        var realm: Realm?
        var viewController: PNNotesFeedViewController? {
            didSet {
                self.controller = viewController
            }
        }
        
        beforeEach {
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            guard let unwrappedMainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationController") as? UINavigationController else {
                print("Notes Feed View Controller is nil")
                return
            }
            
            let sideMenuViewController = PNSideMenuViewController.init()
            let slideMenuController = SlideMenuController(mainViewController: unwrappedMainViewController, leftMenuViewController: sideMenuViewController)
            SlideMenuOptions.contentViewScale = 1
            SlideMenuOptions.hideStatusBar = false
            SlideMenuOptions.contentViewDrag = true
            
            viewController = unwrappedMainViewController.childViewControllers.first as? PNNotesFeedViewController
            UIApplication.shared.keyWindow?.rootViewController = slideMenuController
 
            realm = PNSharedRealm.realmInstance()
        }
        
        describe("view note list") {
            it("with body") {
                guard let unwrappedRealm = realm else {
                    print("Realm is nil")
                    return
                }
                
                var notesList: [Note] = []
                notesList.append(self.note())
                notesList.append(self.note())
                notesList.append(self.note())
                notesList.append(self.note())
                notesList.append(self.note())
            
                for note in notesList {
                    self.add(realm: unwrappedRealm, note: note, notebook: nil)
                }
                
                let oldCountAllNotes = unwrappedRealm.objects(Note.self).count
                
                viewController?.currentNotebook = nil
                viewController?.loadViewProgrammatically()
                
                expect(viewController?.baseView?.notesListTableView.numberOfRows(inSection: 0)).toEventually(equal(oldCountAllNotes))
            }
        }
        
        describe("view notebook") {
            it("with body") {
                guard let unwrappedRealm = realm else {
                    print("Realm is nil")
                    return
                }
                
                var notesList: [Note] = []
                let notebook = self.notebook()
                notesList.append(self.note())
                notesList.append(self.note())
                notesList.append(self.note())
                notesList.append(self.note())
                notesList.append(self.note())
                
                for note in notesList {
                    self.add(realm: unwrappedRealm, note: note, withNotebook: notebook)
                }
                
                let oldCountAllNotes = unwrappedRealm.objects(Note.self).filter(NSPredicate.init(format: "notebook = %@", notebook)).count
 
                viewController?.loadViewProgrammatically()
                viewController?.currentNotebook = notebook
                
                expect(viewController?.baseView?.notesListTableView.numberOfRows(inSection: 0)).toEventually(equal(oldCountAllNotes))
            }
        }
    }
}
