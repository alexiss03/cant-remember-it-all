//
//  PNNotesFeedViewPresenter.swift
//  Memo
//
//  Created by Hanet on 7/21/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import RealmSwift

protocol PNNotesFeedViewEventHandler {
    func handleDelete(notebook notebookToDeleted: Notebook)
    func handleDelete(note noteToBeDeleted: Note)
    func handleSearch(text: String?, currentNotebook: Notebook?)
    func handleEditNotebook(newName: String?, notebook: Notebook)
}

class PNNotesFeedViewPresenter: PNNotesFeedViewEventHandler {
    private let deleteNotebookInteractor: PNDeleteNotebookInteractorInterface
    private let searchNotebookInteractor: PNSearchNoteInteractorInterface
    private let deleteNoteInteractor: PNDeleteNoteInteractorInterface
    private let editNotebookInteractor: PNEditNotebookInteractorInterface
    
    internal var output: PNNotesFeedViewPresenterOutput?
    
    init(deleteNotebookInteractor: PNDeleteNotebookInteractorInterface, searchNotebookInteractor: PNSearchNoteInteractorInterface, deleteNoteInteractor: PNDeleteNoteInteractorInterface, editNotebookInteractor: PNEditNotebookInteractorInterface) {
        self.deleteNotebookInteractor = deleteNotebookInteractor
        self.searchNotebookInteractor = searchNotebookInteractor
        self.deleteNoteInteractor = deleteNoteInteractor
        self.editNotebookInteractor = editNotebookInteractor
    }
    
    internal func handleDelete(notebook notebookToDeleted: Notebook) {
        deleteNotebookInteractor.delete(notebook: notebookToDeleted)
    }
    
    internal func handleDelete(note noteToBeDeleted: Note) {
        deleteNoteInteractor.delete(selectedNote: noteToBeDeleted)
    }
    
    internal func handleSearch(text: String?, currentNotebook: Notebook?) {
        searchNotebookInteractor.search(text: text, currentNotebook: currentNotebook)
    }
    
    internal func handleEditNotebook(newName: String?, notebook: Notebook) {
        editNotebookInteractor.saveNotebook(newName: newName, notebook: notebook)
    }
}

extension PNNotesFeedViewPresenter: PNSearchNoteInteractorOutput, PNEditNotebookInteractorOutput {
    internal func update(notes: Results<Note>) {
        output?.update(notes: notes)
    }
    
    internal func setMenu(title: String) {
        output?.setMenu(title: title)
    }
}

extension PNNotesFeedViewPresenter: PNDeleteNotebookInteractorOutput {
    internal func setMenuToDefault() {
        output?.setMenu(title: nil)
    }
}
