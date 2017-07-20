//
//  PNDeleteNoteInteractor.swift
//  Memo
//
//  Created by Hanet on 6/21/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import RealmSwift

protocol PNDeleteNoteInteractorInterface {
    func delete(selectedNote: Note)
}

/**
 The `PNDeleteNoteInteractor` contains the business logic of the Delete Note module.
 */
struct PNDeleteNoteInteractor: PNDeleteNoteInteractorInterface {
    /**
     Deletes the selected note using from an indexPath, and a filter.
     
     - Parameter indexPath: An `IndexPath` instance that indicates the position of the note from the fetched list.
     - Parameter filter: An `NSPredicate` instance that filters the list of note list.
     */
    public func delete(selectedNote: Note) {
        //let fetchNoteOperation = PNFetchNoteOperation.init(indexPath: indexPath, filter: filter, realm: realm)
        let deleteNoteOperation = PNDeleteNoteOperation.init(selectedNote: selectedNote)
        //deleteNoteOperation.injectResult(from: fetchNoteOperation)
        
        PNOperationQueue.realmOperationQueue.addOperations([deleteNoteOperation], waitUntilFinished: false)
    }
}
