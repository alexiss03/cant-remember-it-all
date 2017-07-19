//
//  PNDeleteNotebookinteractor.swift
//  Memo
//
//  Created by Hanet on 6/26/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import RealmSwift

/**
 The `PNDeleteNotebookInteractor` struct contains the business logic for the Delete Notebook module.
 */
struct PNDeleteNotebookInteractor {
    /// A `Realm` instance where the notebook is to be deleted.
    private var realm: Realm
    private var deleteNotebookPresenter: PNDeleteNotebookPresenter
    
    /**
     Initializes the instance.
     
     - Parameter realm: A `Realm` instance where the notebook is to be deleted.
     */
    public init(realm: Realm, deleteNotebookPresenter: PNDeleteNotebookPresenter) {
        self.realm = realm
        self.deleteNotebookPresenter = deleteNotebookPresenter
    }
    
    /**
     Deletes the notebook, and sets the current notebook in notes feed to nil to update that view controller.
     
     - Parameter notebookToDeleted: A `Notebook` instance to be deleted.
     - Parameter notesFeedViewController: A `PNCurrentNotesContainer` instance that contains the current notebook. This will be set to nil if the delete is successful.
     */
    public func delete(notebook notebookToDeleted: Notebook) {
        let deleteNotebookOperation = PNDeleteNotebookOperation.init(notebook: notebookToDeleted, realm: realm)
        deleteNotebookOperation.add(observer: deleteNotebookPresenter)
        
        PNOperationQueue.realmOperationQueue.add(operation: deleteNotebookOperation)
        
    }
}
