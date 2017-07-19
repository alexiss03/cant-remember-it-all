//
//  PNCreateNotebookInteractor.swift
//  Memo
//
//  Created by Hanet on 6/23/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import RealmSwift

protocol PNCreateNotebookPresenterOutput {
    func update(currentNotebook: Notebook?)
}

struct PNCreateNotebookPresenter {
    private var presenterOutput: PNCreateNotebookPresenterOutput
    
    init(presenterOutput: PNCreateNotebookPresenterOutput) {
        self.presenterOutput = presenterOutput
    }
    
    internal func setNotebook(newNotebook: Notebook?) {
      self.presenterOutput.update(currentNotebook: newNotebook)
    }
    
}

/**
 This class is responsible for the business logic of the Create Notebook module.
 */
final class PNCreateNotebookInteractor {
    private var createNotebookPresenter: PNCreateNotebookPresenter
    /**
     This is the required initialization method.
     */
    internal required init(createNotebookPresenter: PNCreateNotebookPresenter) {
        self.createNotebookPresenter = createNotebookPresenter
    }
    
    /**
     This is an event handler method triggered when a `Notebook` instance is to be created. This method uses `Operation` for its logic.
     - Parameter notebookName: The name of the `Notebook` to be created.
     - Parameter realm: The realm where the new `Notebook` is to be created.
     */
    internal  func create(notebookName: String, realm: Realm) {
        let createNotebookOperation = PNCreateNotebookOperation.init(notebookName: notebookName, realm: realm)
        PNOperationQueue.realmOperationQueue.add(operation: createNotebookOperation)
    }
    
    internal func setNotebook(newNotebook: Notebook?) {
        createNotebookPresenter.setNotebook(newNotebook: newNotebook)
    }
}
