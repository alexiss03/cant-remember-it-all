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
    
    internal  override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initInteractors()

    }
    
    /**
     Initializes the baseView.
     */
    private func initView() {
        if let unwrappedBaseView = baseView {
            unwrappedBaseView.frame = self.view.frame
            
            self.view = unwrappedBaseView
            self.baseView?.addButton.isHidden = true
            self.baseView?.tableView.delegate = self
            self.baseView?.tableView.dataSource = self
            
            let tableViewCellNib = UINib.init(nibName: "PNNotebooksListTableViewCell", bundle: Bundle.main)
            let tableViewCellNibId = "PNNotebooksListTableViewCell"
            unwrappedBaseView.tableView.register(tableViewCellNib, forCellReuseIdentifier: tableViewCellNibId)
            
        }
    }
    
    /**
     Initializes the interactors
     */
    private func initInteractors() {
        if let unwrappedRealm = PNSharedRealm.realmInstance() {
            moveNoteInteractor = PNMoveNoteInteractor.init(realm: unwrappedRealm)
        }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PNMoveNoteViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return 0 }
        let notebookList = unwrappedRealm.objects(Notebook.self)
        
        return notebookList.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PNNotebooksListTableViewCell") as? PNNotebooksListTableViewCell {
            guard let unwrappedRealm = PNSharedRealm.realmInstance() else {  return UITableViewCell.init() }
            let notebookList = unwrappedRealm.objects(Notebook.self).sorted(byKeyPath: "dateCreated", ascending: true)
            cell.setContent(notebook: notebookList[indexPath.row])
            cell.selectionStyle = .none
            
            return cell
        }
        return UITableViewCell.init()
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let unwrappedNote = note {
            moveNoteInteractor?.move(note: unwrappedNote, position: indexPath.row)
        }
     
        dismiss(animated: true, completion: nil)
    }
}
