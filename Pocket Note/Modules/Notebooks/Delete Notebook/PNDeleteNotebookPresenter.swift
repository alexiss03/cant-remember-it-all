//
//  PNDeleteNotebookPresenter.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import ProcedureKit

protocol PNDeleteNotebookPresenterOutput {
    func update(currentNotebook: Notebook?)
}

/**
 The `PNDeleteNotebookPresenter` class observes delete operation. This sets the current notebook of the note list view controller to nil.
 */
class PNDeleteNotebookPresenter: ProcedureObserver {
    private var presenterOutput: PNDeleteNotebookPresenterOutput
    
    /**
     Initializes the instance.
     
     - Parameter notesFeedViewController: A `PNCurrentNotesContainer` instance containing a reference to the current notebook.
     */
    required init(presenterOutput: PNDeleteNotebookPresenterOutput) {
        self.presenterOutput = presenterOutput
    }
    
    /**
     Sets the current notebook of the note list view controller to nil.
     
     - Parameter procedure: A `Procedure` being observed and has finished.
     - Parameter withErrors: An array of `Error`s returned by a procedure while finishing.
     */
    func did(finish procedure: Procedure, withErrors: [Error]) {
        presenterOutput.update(currentNotebook: nil)
    }
}
