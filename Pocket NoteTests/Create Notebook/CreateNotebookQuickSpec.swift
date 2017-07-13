//
//  CreateNotebookQuickSpec.swift
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

protocol NotebookQuickSpecProtocol {
    var controller: UIViewController? {get set}
    
    func notebook() -> Notebook
    //func loadController(note: Note?, notebook: Notebook?)
    func add(realm: Realm, notebook: Notebook?)
}

extension NotebookQuickSpecProtocol {
    func notebook() -> Notebook {
        let notebook = Notebook()
        notebook.notebookId = "\(Date().timeStampFromDate())"
        notebook.dateCreated = Date()
        return notebook
    }
    
    func add(realm: Realm, notebook: Notebook? = nil) {
        do {
            try realm.write {
                if let unwrappedNotebook = notebook {
                    realm.add(unwrappedNotebook)
                }
            }
        } catch { }
    }
}

class CreateNotebookQuickSpec: QuickSpec, NotebookQuickSpecProtocol {
    var controller: UIViewController?
    
    override func spec() {
        var viewController: PNNotebooksListViewController? {
            didSet {
                self.controller = viewController
            }
        }
        var realm: Realm?
        
        beforeEach {
            viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PNNotebooksListViewController") as? PNNotebooksListViewController
            realm = PNSharedRealm.configureDefaultRealm()
        }
        
        describe("create notebook") {
            it("with correct notebook name") {
                
                UIApplication.shared.keyWindow?.rootViewController = viewController
                viewController?.AlertAction = MockAlertAction.self
                
                guard let unwrappedRealm = realm else {
                    print("Realm is nil")
                    return
                }
                
                let oldNotebooksCount = unwrappedRealm.objects(Notebook.self).count
                
                viewController?.loadViewProgrammatically()
                viewController?.addButtonTapped()
                
                guard let alertController = viewController?.presentedViewController as? UIAlertController else {
                    print("Alert controller is nil")
                    return
                }
                
                if let notebookNameTextField = alertController.textFields?.first {
                    notebookNameTextField.text = "Notebook Name"
                }
                
                if let action = alertController.actions.first as? MockAlertAction, let unwrappedActionHandler = action.handler {
                    unwrappedActionHandler(action)
                }
                
                let predicate = NSPredicate.init(format: "name == %@", "Notebook Name")
                expect(unwrappedRealm.objects(Notebook.self).count).toEventually(equal(oldNotebooksCount+1))
                expect(unwrappedRealm.objects(Notebook.self).filter(predicate).count).toEventually(equal(1))
            }
        }
        
        it("with empty notebook name") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            viewController?.AlertAction = MockAlertAction.self
            
            guard let unwrappedRealm = realm else {
                print("Realm is nil")
                return
            }
            
            let oldNotebooksCount = unwrappedRealm.objects(Notebook.self).count
            viewController?.loadViewProgrammatically()
            viewController?.addButtonTapped()
            
            guard let alertController = viewController?.presentedViewController as? UIAlertController else {
                print("Alert controller is nil")
                return
            }
            
            if let notebookNameTextField = alertController.textFields?.first {
                notebookNameTextField.text = ""
            }
            
            if let action = alertController.actions.first as? MockAlertAction, let unwrappedActionHandler = action.handler {
                unwrappedActionHandler(action)
            }
            
            let predicate = NSPredicate.init(format: "name == %@", "")
            expect(unwrappedRealm.objects(Notebook.self).count).toEventually(equal(oldNotebooksCount))
            expect(unwrappedRealm.objects(Notebook.self).filter(predicate).count).toEventually(equal(1))
        }
    }
}

class MockAlertAction: UIAlertAction {
    typealias Handler = ((UIAlertAction) -> Void)
    var handler: Handler?
    var mockTitle: String?
    var mockStyle: UIAlertActionStyle
    
    convenience init(title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?) {
        self.init()
        
        mockTitle = title
        mockStyle = style
        self.handler = handler
    }
    
    override init() {
        mockStyle = .default
        
        super.init()
    }
}
