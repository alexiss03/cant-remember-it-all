//
//  PNNotebooksListPresenter.swift
//  Memo
//
//  Created by Hanet on 7/20/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import UIKit.UIAlertController
import UIKit.UITableView

import RealmSwift
import DZNEmptyDataSet

protocol PNNotebooksListViewEventHandler {
    func handleCreateNote()
}

protocol PNNotebooksListPresenterOutput {
    func presentAlertController(alert: UIAlertController)
}

struct PNNotebooksListPresenter: PNCreateNotebookInteractorOutput, PNNotebooksListViewEventHandler {
    private var createNotebookInteractor: PNCreateNotebookInteractorInterface
    private var output: PNNotebooksListPresenterOutput
    
    init(createNotebookInteractor: PNCreateNotebookInteractorInterface, output: PNNotebooksListPresenterOutput) {
        self.createNotebookInteractor = createNotebookInteractor
        self.output = output
    }
    
    func handleCreateNote() {
        let alertController = UIAlertController(title: "New Notebook", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction.init(title: "Save", style: .default) { (_) in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let unwrappedRealm = PNSharedRealm.configureDefaultRealm() else {
                print("Realm is nil")
                return
            }
            
            guard let unwrappedNotebookName = firstTextField.text else {
                print("Notebook name is nil")
                return
            }
            
            self.createNotebookInteractor.create(notebookName: unwrappedNotebookName, realm: unwrappedRealm)
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Notebook Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        output.presentAlertController(alert: alertController)
    }
}
