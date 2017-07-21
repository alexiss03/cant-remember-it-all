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

struct PNDeleteNotebookPresenter {
    private let deleteInteractor: PNDeleteNotebookInteractorInterface
    
    init(deleteInteractor: PNDeleteNotebookInteractorInterface) {
        self.deleteInteractor = deleteInteractor
    }
    
    func delete(notebook notebookToDeleted: Notebook) {
        deleteInteractor.delete(notebook: notebookToDeleted)
    }
}
