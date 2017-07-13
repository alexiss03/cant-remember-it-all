//
//  DeleteNotebookQuickSpec.swift
//  Memo
//
//  Created by Hanet on 6/26/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Quick
import Nimble

import UIKit
import RealmSwift

@testable import Memo

class DeleteNotebookQuickSpec: QuickSpec, NotebookQuickSpecProtocol {
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
            let notebook = self.notebook()
            
            guard let unwrappedRealm = realm else {
                print("Realm is nil")
                return
            }
            
            guard let notebookId = notebook.notebookId else {
                print("Notebook id is nil")
                return
            }
            
            self.add(realm: unwrappedRealm, notebook: notebook)
            
            viewController?.currentNotebook = notebook
            viewController?.AlertAction = MockAlertAction.self
            UIApplication.shared.keyWindow?.rootViewController = viewController
            
            viewController?.notesEditNotebookInteractor?.showNotebookActions(sender: UIButton.init())
            guard let alertController = viewController?.presentedViewController as? UIAlertController else {
                print("Alert controller is nil")
                return
            }
            
            let oldNotebooksCount = unwrappedRealm.objects(Notebook.self).count
            
            if let notebookNameTextField = alertController.textFields?.first {
                notebookNameTextField.text = ""
            }
            
            if let action = alertController.actions[1] as? MockAlertAction, let unwrappedActionHandler = action.handler {
                unwrappedActionHandler(action)
            }
            
            let predicate = NSPredicate.init(format: "notebookId == %@", notebookId)
            expect(unwrappedRealm.objects(Notebook.self).count).toEventually(equal(oldNotebooksCount-1))
            expect(unwrappedRealm.objects(Notebook.self).filter(predicate).count).toEventually(equal(0))
        }
    }
}
