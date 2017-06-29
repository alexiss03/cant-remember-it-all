//
//  PNDeleteNotebookObserver.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import ProcedureKit

/**
 The `PNDeleteNotebookObserver` class observes delete operation. This sets the current notebook of the note list view controller to nil.
 */
class PNDeleteNotebookObserver: ProcedureObserver {
    /// A `PNNotesFeedViewProtocol` instance containing a reference to the current notebook.
    private var notesFeedViewController: PNNotesFeedViewProtocol
    
    /**
     Initializes the instance.
     
     - Parameter notesFeedViewController: A `PNNotesFeedViewProtocol` instance containing a reference to the current notebook.
     */
    required init(notesFeedViewController: PNNotesFeedViewProtocol) {
        self.notesFeedViewController = notesFeedViewController
    }
    
    /**
     Sets the current notebook of the note list view controller to nil.
     
     - Parameter procedure: A `Procedure` being observed and has finished.
     - Parameter withErrors: An array of `Error`s returned by a procedure while finishing.
     */
    func did(finish procedure: Procedure, withErrors: [Error]) {
        notesFeedViewController.currentNotebook = nil
    }
}
