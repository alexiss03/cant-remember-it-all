//
//  PNNotesEditNotebookInteractor.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

class PNNotesEditNotebookInteractor: NoteFeedMenu {
    private var presentationContext: UIViewController
    private var navigationItem: UINavigationItem
    private var navigationController: UINavigationController?
    private var deleteNotebookInteractor: PNDeleteNotebookInteractor?
    private var notesFeedView: PNNotesFeedViewProtocol
    private var AlertAction: UIAlertAction.Type
    weak private var delegate: UIPopoverPresentationControllerDelegate?
    weak private var currentNotebookHolder: PNNotesFeedViewProtocol?
    
    init(presentationContext: UIViewController, navigationItem: UINavigationItem, navigationController: UINavigationController?, deleteNotebookInteractor: PNDeleteNotebookInteractor?, notesFeedView: PNNotesFeedViewProtocol, AlertAction: UIAlertAction.Type, delegate: UIPopoverPresentationControllerDelegate?, currentNotebookHolder: PNNotesFeedViewProtocol) {
        self.presentationContext = presentationContext
        self.navigationItem = navigationItem
        self.navigationController = navigationController
        self.deleteNotebookInteractor = deleteNotebookInteractor
        self.notesFeedView = notesFeedView
        self.AlertAction = AlertAction
        self.delegate = delegate
        self.currentNotebookHolder = currentNotebookHolder
    }
    
    func editNotebookPopUp(currentNotebook: Notebook) {
        let alertController = UIAlertController(title: "Edit Notebook", message: "", preferredStyle: .alert)
        
        let saveAction = saveNotebookAction(alertController: alertController, currentNotebook: currentNotebook)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (_ : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "New Notebook Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        presentationContext.present(alertController, animated: true, completion: nil)
    }
    
    func saveNotebookAction(alertController: UIAlertController, currentNotebook: Notebook) -> UIAlertAction {
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print("firstName \(String(describing: firstTextField.text))")
            
            guard let unwrappedRealm = PNSharedRealm.configureDefaultRealm() else { return }
            do {
                try unwrappedRealm.write {
                    currentNotebook.name = firstTextField.text
                    
                    if let currentNotebookName = currentNotebook.name {
                        self.setMenu(title: currentNotebookName, target: self.currentNotebookHolder, action: #selector(PNNotesFeedViewController.openNotebooks), navigationItem: self.navigationItem, navigationBar: self.navigationController?.navigationBar)
                    }
                }
            } catch { }
        })
        return saveAction
    }
    
    @objc public func showNotebookActions(sender: UIButton) {
        let alertController = UIAlertController(title: "Notebook Settings", message: "", preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.delegate = delegate
        
        let editNotebookAction = AlertAction.init(title: "Edit Notebook", style: .default, handler: { _ -> Void in
            if let currentNotebook = self.currentNotebookHolder?.currentNotebook {
                self.editNotebookPopUp(currentNotebook: currentNotebook)
            }
        })
        
        let deleteNotebookAction = AlertAction.init(title: "Delete Notebook", style: .default, handler: { (_ : UIAlertAction!) -> Void in
            if let currentNotebook = self.currentNotebookHolder?.currentNotebook {
                self.deleteNotebookInteractor?.delete(notebook: currentNotebook, notesFeedViewController: self.notesFeedView)
            }
        })
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(editNotebookAction)
        alertController.addAction(deleteNotebookAction)
        alertController.addAction(cancelAction)
        
        presentationContext.present(alertController, animated: true, completion: nil)
    }

}
