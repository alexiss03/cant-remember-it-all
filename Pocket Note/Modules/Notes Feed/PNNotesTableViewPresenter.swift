//
//  PNNotesTableViewPresenter.swift
//  Memo
//
//  Created by Hanet on 7/19/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

protocol PNNotesTableViewPresenterOutput {
    func openMoveNoteToANotebook(note: Note)
    func pushToCreateNote()
}

struct PNNotesTableViewPresenter {
    private var presenterOutput: PNNotesTableViewPresenterOutput
    
    init(presenterOutput: PNNotesTableViewPresenterOutput) {
        self.presenterOutput = presenterOutput
    }
    
    internal func openMoveNoteToANotebook(note: Note) {
        presenterOutput.openMoveNoteToANotebook(note: note)
    }
    
    internal func pushToCreateNote() {
        presenterOutput.pushToCreateNote()
    }
}
