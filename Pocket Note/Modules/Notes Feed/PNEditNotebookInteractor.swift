//
//  PNEditNotebookInteractor.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import RealmSwift

protocol PNEditNotebookInteractorInterface {
    func saveNotebook(newName: String?, notebook: Notebook)
}

protocol PNEditNotebookInteractorOutput {
    func setMenu(title: String)
}

/**
 The `PNEditNotebookInteractor` class contains the business logic for edit notebook's details and delete notebook.
 */
class PNEditNotebookInteractor: PNEditNotebookInteractorInterface {
    internal var output: PNEditNotebookInteractorOutput?
    
    private var realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    internal func saveNotebook(newName: String?, notebook: Notebook) {

        do {
            try realm.write {
                notebook.name = newName
                
                if let unwrappedNewName = newName {
                    output?.setMenu(title: unwrappedNewName)
                }
            }
        } catch { }
    }

}
