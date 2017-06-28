//
//  PNDeleteNoteInteractor.swift
//  Memo
//
//  Created by Hanet on 6/21/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import RealmSwift

/**
 The `PNDeleteNoteInteractor` contains the business logic of the Delete Note module.
 */
class PNDeleteNoteInteractor {
    /// A `Realm` instance where the note is to be deleted.
    private var realm: Realm
    
    /**
     Initializes the instance.
     
     - Parameter realm: A `Realm` instance where the note is to be deleted.
     */
    required init(realm: Realm) {
        self.realm = realm
    }
    
    /**
     Deletes the selected note using from an indexPath, and a filter.
     
     - Parameter indexPath: An `IndexPath` instance that indicates the position of the note from the fetched list.
     - Parameter filter: An `NSPredicate` instance that filters the list of note list.
     */
    public func deleteSelectedNote(indexPath: IndexPath, filter: NSPredicate?) {
        let fetchNoteOperation = PNFetchNoteOperation.init(indexPath: indexPath, filter: filter, realm: realm)
        let deleteNoteOperation = PNDeleteNoteOperation.init(realm: realm)
        deleteNoteOperation.injectResult(from: fetchNoteOperation)
        
        PNOperationQueue.realmOperationQueue.addOperations([fetchNoteOperation, deleteNoteOperation], waitUntilFinished: false)
    }
}
