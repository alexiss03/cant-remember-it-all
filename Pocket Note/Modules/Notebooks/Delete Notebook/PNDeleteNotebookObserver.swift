//
//  PNDeleteNotebookObserver.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import ProcedureKit

class PNDeleteNotebookObserver: ProcedureObserver {
    var notesFeedViewController: PNNotesFeedViewProtocol
    
    required init(notesFeedViewController: PNNotesFeedViewProtocol) {
        self.notesFeedViewController = notesFeedViewController
    }
    
    func did(finish procedure: Procedure, withErrors: [Error]) {
        notesFeedViewController.currentNotebook = nil
    }
}
