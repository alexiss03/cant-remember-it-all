//
//  PNNewNotebooksViewController.swift
//  Pocket Note
//
//  Created by Hanet on 5/2/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

class PNNotebooksListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var AlertAction = UIAlertAction.self
    
    let baseView: PNNotebooksListView? = {
        if let view = Bundle.main.loadNibNamed("PNNotebooksListView", owner: self, options: nil)![0] as? PNNotebooksListView {
            return view
        }
        return nil
    }()
    
    fileprivate var createNotebookInteractor: PNCreateNotebookInteractor?
    
    var notificationToken: NotificationToken?
    weak var notesFeedDelegate: PNNotesFeedViewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let unwrappedBaseView = baseView {
            unwrappedBaseView.frame = self.view.frame
            unwrappedBaseView.delegate = self

            self.view = unwrappedBaseView
            self.baseView?.tableView.delegate = self
            self.baseView?.tableView.dataSource = self
            
            let tableViewCellNib = UINib.init(nibName: "PNNotebooksListTableViewCell", bundle: Bundle.main)
            let tableViewCellNibId = "PNNotebooksListTableViewCell"
            unwrappedBaseView.tableView.register(tableViewCellNib, forCellReuseIdentifier: tableViewCellNibId)
            
            initInteractors()
        }
    }

    private func initInteractors() {
        createNotebookInteractor = PNCreateNotebookInteractor.init()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return }
        let results = unwrappedRealm.objects(Notebook.self).sorted(byKeyPath: "dateCreated", ascending: true)
        
        if let unwrappedNotebookListTableView = baseView?.tableView {
            notificationToken = results.addNotificationBlock(unwrappedNotebookListTableView.applyChanges)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return 0 }
        let notebookList = unwrappedRealm.objects(Notebook.self)
        
        return notebookList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PNNotebooksListTableViewCell") as? PNNotebooksListTableViewCell {
            guard let unwrappedRealm = PNSharedRealm.realmInstance() else {  return UITableViewCell.init() }
            let notebookList = unwrappedRealm.objects(Notebook.self).sorted(byKeyPath: "dateCreated", ascending: true)
            cell.setContent(notebook: notebookList[indexPath.row])
            cell.selectionStyle = .none

            return cell
        }
        return UITableViewCell.init()
    }

    func setMenu() {

    }

    private func showCreateNote() {
        self.performSegue(withIdentifier: "TO_CREATE_NOTE", sender: self)
    }

    func showViewNote() {
        self.performSegue(withIdentifier: "TO_CREATE_NOTE", sender: self)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return }
        let results = unwrappedRealm.objects(Notebook.self).sorted(byKeyPath: "dateCreated", ascending: true)
        
        notesFeedDelegate?.currentNotebook = results[indexPath.row]

        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("PNNotebookListViewHeaderFooterCell", owner: self, options: nil)![0] as? UIView
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(allNotesTapped))
        header?.addGestureRecognizer(tapRecognizer)
        return header
    }

    func allNotesTapped() {
        notesFeedDelegate?.currentNotebook = nil
        dismiss(animated: true, completion: nil)
    }
}

extension PNNotebooksListViewController: PNNotebooksListViewDelegate {
    public func addButtonTapped() {
        let alertController = UIAlertController(title: "New Notebook", message: "", preferredStyle: .alert)
        
        weak var weakSelf = self
        let saveAction = AlertAction.init(title: "Save", style: .default, handler: { _ -> Void in
            guard let strongSelf = weakSelf else {
                print("Weak self is nil")
                return
            }
            
            let firstTextField = alertController.textFields![0] as UITextField
            guard let unwrappedRealm = PNSharedRealm.configureDefaultRealm() else {
                print("Realm is nil")
                return
            }
            
            guard let unwrappedNotebookName = firstTextField.text else {
                print("Notebook name is nil")
                return
            }
            
            strongSelf.createNotebookInteractor?.create(notebookName: unwrappedNotebookName, realm: unwrappedRealm)
        })
        
        let cancelAction = AlertAction.init(title: "Cancel", style: .default, handler: { (_ : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Notebook Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
