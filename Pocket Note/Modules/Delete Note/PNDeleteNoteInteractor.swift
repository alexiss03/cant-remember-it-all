//
//  PNDeleteNoteInteractor.swift
//  Memo
//
//  Created by Hanet on 6/21/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import RealmSwift

class PNDeleteNoteInteractor {
    
    required init() { }
    
    public func deleteSelectedNote(indexPath: IndexPath, filter: NSPredicate?, realm: Realm) {
        let fetchNoteOperation = PNFetchNoteOperation.init(indexPath: indexPath, filter: filter, realm: realm)
        let deleteNoteOperation = PNDeleteNoteOperation.init(realm: realm)
        deleteNoteOperation.injectResult(from: fetchNoteOperation)
        
        PNOperationQueue.realmOperationQueue.addOperations([fetchNoteOperation, deleteNoteOperation], waitUntilFinished: false)
    }
}
