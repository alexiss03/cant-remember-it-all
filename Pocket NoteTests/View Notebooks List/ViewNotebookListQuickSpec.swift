//
//  ViewNotebookListQuickSpec.swift
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

class ViewNotebookListQuickSpec: QuickSpec, NotebookQuickSpecProtocol {
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
        
        it("view notebook list") {
            guard let unwrappedRealm = realm else {
                print("Realm is nil")
                return
            }
            
            var notebooksList: [Notebook] = []
            notebooksList.append(self.notebook())
            notebooksList.append(self.notebook())
            notebooksList.append(self.notebook())
            notebooksList.append(self.notebook())
            notebooksList.append(self.notebook())
            
            for notebook in notebooksList {
                self.add(realm: unwrappedRealm, notebook: notebook)
            }
            
            let oldNotebooksCount = unwrappedRealm.objects(Notebook.self).count
            viewController?.loadViewProgrammatically()
            
            expect(viewController?.baseView?.tableView.numberOfRows(inSection: 0)).toEventually(equal(oldNotebooksCount))
        }
        
        it("view notebook list no notebook") {
            guard let unwrappedRealm = realm else {
                print("Realm is nil")
                return
            }
            
            let oldNotebooksCount = unwrappedRealm.objects(Notebook.self).count
            viewController?.loadViewProgrammatically()

            expect(viewController?.baseView?.tableView.numberOfRows(inSection: 0)).toEventually(equal(oldNotebooksCount))
        }
    }
}
