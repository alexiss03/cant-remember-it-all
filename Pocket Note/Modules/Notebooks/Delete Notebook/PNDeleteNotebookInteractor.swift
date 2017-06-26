//
//  PNDeleteNotebookinteractor.swift
//  Memo
//
//  Created by Hanet on 6/26/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import RealmSwift

final class PNDeleteNotebookInteractor {
    public required init() { }
    
    public func delete(notebook notebookToDeleted: Notebook, realm: Realm, notesFeedViewControler: PNNotesFeedViewProtocol) {
        let deleteNotebookObserver = PNDeleteNotebookObserver.init(notesFeedViewController: notesFeedViewControler)
        let deleteNotebookOperation = PNDeleteNotebookOperation.init(notebook: notebookToDeleted, realm: realm)
        deleteNotebookOperation.add(observer: deleteNotebookObserver)
        
        PNOperationQueue.realmOperationQueue.add(operation: deleteNotebookOperation)
        
    }
}
