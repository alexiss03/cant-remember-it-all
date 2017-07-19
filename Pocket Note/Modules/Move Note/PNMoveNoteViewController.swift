//
//  PNMoveNoteViewController.swift
//  Pocket Note
//
//  Created by Hanet on 5/2/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

/**
 The `PNMoveNoteViewController` class is the custom view controller for the Move Note module.
 */
class PNMoveNoteViewController: UIViewController {
    /// A `PNNotebooksListView` instance serving as the superview of the controller.
    let baseView: PNNotebooksListView? = {
        if let view = Bundle.main.loadNibNamed("PNNotebooksListView", owner: self, options: nil)![0] as? PNNotebooksListView {
            return view
        }
        return nil
    }()
    
    /// A `NotificationToken` instance indicating the notification observer for the list of notebooks.
    var notificationToken: NotificationToken?
    /// A `Note` instance to be moved to a new `Notebook`.
    var note: Note?
    
    /// A `PNMoveNoteInteractor` instance containing the moving of the note in a `Realm` instance.
    var moveNoteInteractor: PNMoveNoteInteractor?
    var tableViewInteractor: PNMoveNoteTableViewInteractor?
    
    internal  override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        initInteractors()
    }

    /**
     Initializes the baseView.
     */
    private func setUpView() {
        if let unwrappedBaseView = baseView {
            unwrappedBaseView.frame = self.view.frame
            self.view = unwrappedBaseView
        }
    }
    
    /**
     Initializes the interactors
     */
    private func initInteractors() {
        if let unwrappedRealm = PNSharedRealm.realmInstance() {
            moveNoteInteractor = PNMoveNoteInteractor.init(realm: unwrappedRealm)
        }
        
        if let unwrappedNote = note, let unwrappedTableView = baseView?.tableView, let unwrappedMoveNoteInteractor = moveNoteInteractor {
            let tableViewPresenter = PNMoveNoteTableViewPresenter.init(presentationContext: self)
            tableViewInteractor = PNMoveNoteTableViewInteractor.init(noteToMove: unwrappedNote, tableView: unwrappedTableView, moveNoteInteractor: unwrappedMoveNoteInteractor, moveNoteTableViewPresenter: tableViewPresenter)
        }
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addTableNotificationBlock()
    }
    
    /**
     Adds the notificaton block for the tableView in baseView.
     
     This tableView displays the list of existing notebooks that can be chosen.
     */
    private func addTableNotificationBlock() {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else {
            print("Realm is nil")
            return
        }
        let results = unwrappedRealm.objects(Notebook.self).sorted(byKeyPath: "dateCreated", ascending: true)
        
        if let unwrappedNotebookListTableView = baseView?.tableView {
            notificationToken = results.addNotificationBlock(unwrappedNotebookListTableView.applyChanges)
        }
    }
}
