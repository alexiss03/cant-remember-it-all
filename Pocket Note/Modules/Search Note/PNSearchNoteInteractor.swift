//
//  PNSearchNoteInteractor.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

protocol PNSearchNoteInteractorOutput {
    func update(notes: Results<Note>)
    func setMenu(title: String)
}

protocol PNSearchNoteInteractorInterface {
    func search(text: String?, currentNotebook: Notebook?)
}
/**
 The `PNSearchNoteInteractor` contains the business logic for Search module.
*/
class PNSearchNoteInteractor: PNSearchNoteInteractorInterface {
    var output: PNSearchNoteInteractorOutput?
    
    func search(text: String?, currentNotebook: Notebook?) {
        DispatchQueue.main.async {
            guard let unwrappedRealm = PNSharedRealm.configureDefaultRealm() else {
                return
            }
            
            if let unwrappedSearchText = text, let unwrappedCurrentNotebook = currentNotebook, let notebookName = unwrappedCurrentNotebook.name {
                let notebookFilter = NSPredicate.init(format: "notebook == %@ && (body CONTAINS[c] %@ || title CONTAINS[c] %@)", unwrappedCurrentNotebook, unwrappedSearchText, unwrappedSearchText)
                let notes = unwrappedRealm.objects(Note.self).filter(notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
                self.output?.update(notes: notes)
                self.output?.setMenu(title: notebookName)
                
            } else if let unwrappedSearchText = text, currentNotebook == nil {
                let notebookFilter = NSPredicate.init(format: "body CONTAINS[c] %@ || title CONTAINS[c] %@", unwrappedSearchText, unwrappedSearchText)
                let notes = unwrappedRealm.objects(Note.self).filter(notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
                self.output?.update(notes: notes)
                self.output?.setMenu(title: "MEMO")
            } else if let unwrappedCurrentNotebook = currentNotebook, let notebookName = unwrappedCurrentNotebook.name, text == nil {
                let notebookFilter = NSPredicate.init(format: "notebook == %@", unwrappedCurrentNotebook)
                let notes = unwrappedRealm.objects(Note.self).filter(notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
                self.output?.update(notes: notes)
                self.output?.setMenu(title: notebookName)
            } else {
                let notebookFilter = NSPredicate.init(format: "dateCreated != nil")
                let notes = unwrappedRealm.objects(Note.self).filter(notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
                self.output?.update(notes: notes)
                self.output?.setMenu(title: "MEMO")
            }

        }
    }
    
}
