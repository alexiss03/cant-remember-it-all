//
//  EditNotenookQuickSpec.swift
//  Memo
//
//  Created by Hanet on 6/30/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import Quick
import Nimble

import UIKit
import RealmSwift

@testable import Memo

class EditNotenookQuickSpec: QuickSpec, NotebookQuickSpecProtocol {
    var controller: UIViewController?
    
    override func spec() {
        var viewController: PNNotesFeedViewController? {
            didSet {
                self.controller = viewController
            }
        }
        var realm: Realm?
        
        beforeEach {
            viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PNNotesFeedViewController") as? PNNotesFeedViewController
            realm = PNSharedRealm.configureDefaultRealm()
        }
        
        it("delete a notebook") {

            let notebook = self.notebookInstance()
            
            guard let unwrappedRealm = realm else {
                print("Realm is nil")
                return
            }
            
            self.add(realm: unwrappedRealm, notebook: notebook)
            
            viewController?.currentNotebook = notebook
            viewController?.AlertAction = MockAlertAction.self
            UIApplication.shared.keyWindow?.rootViewController = viewController
            
            let oldNotebooksCount = unwrappedRealm.objects(Notebook.self).count
            viewController?.notesEditNotebookInteractor?.editNotebookPopUp(currentNotebook: notebook)
            
            guard let editNotebookAlertController = viewController?.presentedViewController as? UIAlertController else {
                print("Alert controller is nil")
                return
            }
            
            if let notebookNameTextField = editNotebookAlertController.textFields?.first {
                notebookNameTextField.text = "New Notebook"
            }
            
            if let action = editNotebookAlertController.actions[0] as? MockAlertAction, let unwrappedActionHandler = action.handler {
                unwrappedActionHandler(action)
            }
            
            let predicate = NSPredicate.init(format: "name == %@", "New Notebook")
            expect(unwrappedRealm.objects(Notebook.self).count).toEventually(equal(oldNotebooksCount))
            expect(unwrappedRealm.objects(Notebook.self).filter(predicate).count).toEventually(equal(0))
        }
    }
}
