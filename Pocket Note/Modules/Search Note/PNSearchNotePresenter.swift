//
//  PNSearchNotePresenter.swift
//  Memo
//
//  Created by Hanet on 7/19/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import CoreData

protocol PNSearchNotePresenterOutput {
    func update(notebookFilter: NSPredicate)
    func update(searchText: String?)
}

struct PNSearchNotePresenter {
    private var presenterOutput: PNSearchNotePresenterOutput
    
    init(presenterOutput: PNSearchNotePresenterOutput) {
        self.presenterOutput = presenterOutput
    }
    
    internal func update(notebookFilter: NSPredicate) {
        presenterOutput.update(notebookFilter: notebookFilter)
    }
    
    internal func update(searchText: String?) {
        presenterOutput.update(searchText: searchText)
    }
}
