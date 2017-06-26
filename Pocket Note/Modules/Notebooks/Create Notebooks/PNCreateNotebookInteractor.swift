//
//  PNCreateNotebookInteractor.swift
//  Memo
//
//  Created by Hanet on 6/23/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import RealmSwift

class PNCreateNotebookInteractor {
    public required init() { }
    
    public func create(notebookName: String, realm: Realm) {
        let createNotebookOperation = PNCreateNotebookOperation.init(notebookName: notebookName, realm: realm)
        PNOperationQueue.realmOperationQueue.add(operation: createNotebookOperation)
    }
}
