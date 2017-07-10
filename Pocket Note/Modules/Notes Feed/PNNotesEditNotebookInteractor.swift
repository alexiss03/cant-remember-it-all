//
//  PNNotesEditNotebookInteractor.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

/**
 The `PNNotesEditNotebookInteractor` class contains the business logic for edit notebook's details and delete notebook.
 */
class PNNotesEditNotebookInteractor: NoteFeedMenu {
    /// A `UIViewController` instance where alert controller's are to be presented.
    private var presentationContext: UIViewController
    /// A `UINavigationItem` instance representing the navigation item of the current view controller presented.
    private var navigationItem: UINavigationItem
    /// An optional UINavigationController instance representing the current navigation controller of he current view controller presented.
    private var navigationController: UINavigationController?
    /// An optional `PNDeleteNotebookInteractor` instance containing the business logic for deleting a notebook.
    private var deleteNotebookInteractor: PNDeleteNotebookInteractor?
    /// A `UIAlertAction.Type` instance used for mocking `UIAlertAction`.
    private var AlertAction: UIAlertAction.Type
    /// A `UIPopoverPresentationControllerDelegate` instance conforming to the delegate.
    weak private var delegate: UIPopoverPresentationControllerDelegate?
    /// A `PNCurrentNotesContainer` instance containing the currentNotebook of the notes feed view controller.
    weak private var currentNotebookHolder: PNCurrentNotesContainer?
    
    /**
     Initializes the instance.
     
     - Parameter presentationContext: A `UIViewController` instance where alert controller's are to be presented. 
     - Parameter navigationItem: A `UINavigationItem` instance representing the navigation item of the current view controller presented.
     - Parameter navigationController: An optional `PNDeleteNotebookInteractor` instance containing the business logic for deleting a notebook.
     - Parameter deleteNotebookInteractor: An optional `PNDeleteNotebookInteractor` instance containing the business logic for deleting a notebook.
     - Parameter AlertAction:  A `UIAlertAction.Type` instance used for mocking `UIAlertAction`.
     - Parameter delegate: A `UIPopoverPresentationControllerDelegate` instance conforming to the delegate.
     - Parameter currentNotebookHolder:  A `PNCurrentNotesContainer` instance containing the currentNotebook of the notes feed view controller.
     */
    init(presentationContext: UIViewController, navigationItem: UINavigationItem, navigationController: UINavigationController?, deleteNotebookInteractor: PNDeleteNotebookInteractor?, AlertAction: UIAlertAction.Type, delegate: UIPopoverPresentationControllerDelegate?, currentNotebookHolder: PNCurrentNotesContainer) {
        self.presentationContext = presentationContext
        self.navigationItem = navigationItem
        self.navigationController = navigationController
        self.deleteNotebookInteractor = deleteNotebookInteractor
        self.AlertAction = AlertAction
        self.delegate = delegate
        self.currentNotebookHolder = currentNotebookHolder
    }
    
    /**
     Show the edit note book input pop up.
     
     - Parameter currentNotebook: A `Notebook` instance representing the notebook to be edited.
     */
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
    
    /**
     Creates an instance of `UIAlertAction` when the user taps the save button.
     
     - Parameter alertController: An `UIAlertController` instance that is to be the receiver of the alert action.
     - Parameter currentNotebook: A `Notebook` instance represeting the notebook to updated.
     */
    func saveNotebookAction(alertController: UIAlertController, currentNotebook: Notebook) -> UIAlertAction {
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print("firstName \(String(describing: firstTextField.text))")
            
            guard let unwrappedRealm = PNSharedRealm.configureDefaultRealm() else { return }
            do {
                try unwrappedRealm.write {
                    currentNotebook.name = firstTextField.text
                    
                    if let currentNotebookName = currentNotebook.name, let menuViewController = self.presentationContext.navigationController?.parent as? SlideMenuController {
                        self.setMenu(title: currentNotebookName, target: self.currentNotebookHolder, action: #selector(PNNotesFeedViewController.openNotebooks), viewController: self.presentationContext, slideController: menuViewController)
                    }
                }
            } catch { }
        })
        return saveAction
    }
    
    /**
     Shows the notebook actions such as Edit Notebook and Delete Notebook.
     
     - Parameter sender: Sender object of this selector.
     */
    @objc public func showNotebookActions(sender: UIButton) {
        let alertController = UIAlertController(title: "Notebook Settings", message: "", preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.delegate = delegate
        
        let editNotebookAction = AlertAction.init(title: "Edit Notebook", style: .default, handler: { _ -> Void in
            if let currentNotebook = self.currentNotebookHolder?.currentNotebook {
                self.editNotebookPopUp(currentNotebook: currentNotebook)
            }
        })
        
        let deleteNotebookAction = AlertAction.init(title: "Delete Notebook", style: .default, handler: { (_ : UIAlertAction!) -> Void in
            if let currentNotebook = self.currentNotebookHolder?.currentNotebook, let unwrappedCurrentNotebookHolder = self.currentNotebookHolder {
                self.deleteNotebookInteractor?.delete(notebook: currentNotebook, notesFeedViewController: unwrappedCurrentNotebookHolder)
            }
        })
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(editNotebookAction)
        alertController.addAction(deleteNotebookAction)
        alertController.addAction(cancelAction)
        
        presentationContext.present(alertController, animated: true, completion: nil)
    }

}
