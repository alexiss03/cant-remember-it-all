//
//  PNMoveNoteViewController.swift
//  Pocket Note
//
//  Created by Hanet on 5/2/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

protocol PNMoveNoteViewEventHandler {
    func handleMove(note: Note, toNotebook newNotebook: Notebook)
}
    
class PNMoveNoteViewPresenter: PNMoveNoteViewEventHandler {
    private let moveNoteInteractor: PNMoveNoteInteractorInterface
    
    init(moveNoteInteractor: PNMoveNoteInteractorInterface) {
        self.moveNoteInteractor = moveNoteInteractor
    }
    
    func handleMove(note: Note, toNotebook newNotebook: Notebook) {
        moveNoteInteractor.move(note: note, toNotebook: newNotebook)
    }
}

/**
 The `PNMoveNoteViewController` class is the custom view controller for the Move Note module.
 */
class PNMoveNoteViewController: UIViewController {
    /// A `PNNotebooksListView` instance serving as the superview of the controller.
    fileprivate let baseView: PNNotebooksListView? = {
        if let view = Bundle.main.loadNibNamed("PNNotebooksListView", owner: self, options: nil)![0] as? PNNotebooksListView {
            return view
        }
        return nil
    }()
    
    /// A `NotificationToken` instance indicating the notification observer for the list of notebooks.
    fileprivate var notificationToken: NotificationToken?
    /// A `Note` instance to be moved to a new `Notebook`.
    var note: Note?
    
    fileprivate var notebooks: Results<Notebook>? = {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else {
            return nil
        }

        let results = unwrappedRealm.objects(Notebook.self).sorted(byKeyPath: "dateUpdated", ascending: false)
        return results
    }()

    fileprivate var eventHandler: PNMoveNoteViewEventHandler?
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        initEventHandler()
    }

    /**
     Initializes the baseView.
     */
    fileprivate func setUpView() {
        guard let unwrappedBaseView = baseView else {
            print("Base view is nil")
            return
        }
        
        unwrappedBaseView.frame = self.view.frame
        self.view = unwrappedBaseView
        
        let tableView = unwrappedBaseView.tableView
        tableView?.delegate = self
        tableView?.dataSource = self

        let tableViewCellNib = UINib.init(nibName: "PNNotebooksListTableViewCell", bundle: Bundle.main)
        tableView?.register(tableViewCellNib, forCellReuseIdentifier: "PNNotebooksListTableViewCell")
    }
    
    /**
     Initializes the interactors
     */
    fileprivate func initEventHandler() {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else {
            print("Realm is nil")
            return
        }
        
        let moveNoteInteractor = PNMoveNoteInteractor.init(realm: unwrappedRealm)
        let moveNotePresenter = PNMoveNoteViewPresenter.init(moveNoteInteractor: moveNoteInteractor)
        
        eventHandler = moveNotePresenter
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addTableNotificationBlock()
    }
    
    /**
     Adds the notificaton block for the tableView in baseView.
     
     This tableView displays the list of existing notebooks that can be chosen.
     */
    fileprivate func addTableNotificationBlock() {
        if let unwrappedNotebookListTableView = baseView?.tableView {
            notificationToken = notebooks?.addNotificationBlock(unwrappedNotebookListTableView.applyChanges)
        }
    }
}

extension PNMoveNoteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return 0 }
        let notebookList = unwrappedRealm.objects(Notebook.self)
        
        return notebookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PNNotebooksListTableViewCell") as? PNNotebooksListTableViewCell, let unwrappedNotebooks = notebooks {
            cell.setContent(notebook: unwrappedNotebooks[indexPath.row])
            cell.selectionStyle = .none
            
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let unwrappedNote = note, let unwrappedNotebooks = notebooks {
            eventHandler?.handleMove(note: unwrappedNote, toNotebook: unwrappedNotebooks[indexPath.row])
        }

        dismiss(animated: true, completion: nil)
    }
}
