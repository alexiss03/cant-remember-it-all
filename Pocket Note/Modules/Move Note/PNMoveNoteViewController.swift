//
//  PNMoveNoteViewController.swift
//  Pocket Note
//
//  Created by Hanet on 5/2/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

class PNMoveNoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let baseView: PNNotebooksListView? = {
        if let view = Bundle.main.loadNibNamed("PNNotebooksListView", owner: self, options: nil)![0] as? PNNotebooksListView {
            return view
        }
        return nil
    }()
    
    var notificationToken: NotificationToken?

    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        let notebookList = unwrappedRealm.objects(Notebook.self).sorted(byKeyPath: "dateCreated", ascending: true)
        
        do {
            try? unwrappedRealm.write {
                note?.notebook = notebookList[indexPath.row]
                note?.dateUpdated = Date()
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension PNNotebooksListViewController: PNNotebooksListViewDelegate {
    func addButtonTapped() {
        let alertController = UIAlertController(title: "New Notebook", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print("firstName \(String(describing: firstTextField.text))")
            guard let unwrappedRealm = PNSharedRealm.configureDefaultRealm() else { return }
            
            let notebook = Notebook()
            notebook.notebookId = "\(Date().timeStampFromDate())"
            notebook.name = firstTextField.text
            notebook.dateCreated = Date()
            
            do {
                try unwrappedRealm.write {
                    unwrappedRealm.add(notebook)
                }
            } catch { }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (_ : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Notebook Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
