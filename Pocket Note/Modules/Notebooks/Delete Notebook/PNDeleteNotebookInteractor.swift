//
//  PNDeleteNotebookinteractor.swift
//  Memo
//
//  Created by Hanet on 6/26/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import RealmSwift

protocol PNDeleteNotebookInteractorInterface {
    func delete(notebook notebookToDeleted: Notebook)
}

protocol PNDeleteNotebookInteractorOutput {
    func setMenuToDefault()
    func update(notes: Results<Note>)
}

/**
 The `PNDeleteNotebookInteractor` struct contains the business logic for the Delete Notebook module.
 */
class PNDeleteNotebookInteractor: PNDeleteNotebookInteractorInterface {
    var output: PNDeleteNotebookInteractorOutput?
    
    /// A `Realm` instance where the notebook is to be deleted.
    private var realm: Realm
    
    /**
     Initializes the instance.
     
     - Parameter realm: A `Realm` instance where the notebook is to be deleted.
     */
    init(realm: Realm) {
        self.realm = realm
    }
    
    /**
     Deletes the notebook, and sets the current notebook in notes feed to nil to update that view controller.
     
     - Parameter notebookToDeleted: A `Notebook` instance to be deleted.
     - Parameter notesFeedViewController: A `PNCurrentNotesContainer` instance that contains the current notebook. This will be set to nil if the delete is successful.
     */
    func delete(notebook notebookToDeleted: Notebook) {
        let deleteNotebookOperation = PNDeleteNotebookOperation.init(notebook: notebookToDeleted, realm: realm)
        PNOperationQueue.realmOperationQueue.add(operation: deleteNotebookOperation)
        
        let notebookFilter = NSPredicate.init(format: "dateCreated != nil")
        let notes = realm.objects(Note.self).filter(notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
        output?.update(notes: notes)
        output?.setMenuToDefault()
    }
}
