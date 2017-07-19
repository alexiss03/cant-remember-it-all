//
//  PNNewNotebooksViewController.swift
//  Pocket Note
//
//  Created by Hanet on 5/2/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

protocol PNNotebooksListViewControllerOutput {
    func update(currentNotebook: Notebook?)
}

/**
 This is the custom `UIViewController` for the Notebook List module.
 */
final class PNNotebooksListViewController: UIViewController {
    /// This property contains the alert action to be used. This is for mocking.
    var AlertAction = UIAlertAction.self
    
    /// This `PNNotebooksListView` is set to be the superview of this view controller.
    let baseView: PNNotebooksListView? = {
        if let view = Bundle.main.loadNibNamed("PNNotebooksListView", owner: self, options: nil)![0] as? PNNotebooksListView {
            return view
        }
        return nil
    }()
    
    /// This interactor is responsible for creating a notebook
    fileprivate var createNotebookInteractor: PNCreateNotebookInteractor?
    /// This is the storage of the notification token of the notification block of the list of `Notes`
    fileprivate var notificationToken: NotificationToken?
    /// This contains the delegate to the `PNCurrentNotesContainer`. This is to get a reference to the current notebook in the notes fed
    //weak var notesFeedDelegate: PNCurrentNotesContainer?
    
    internal var output: PNNotebooksListViewControllerOutput?
    
    internal override func viewDidLoad() {
        super.viewDidLoad()

        if let unwrappedBaseView = baseView {
            unwrappedBaseView.frame = self.view.frame
            unwrappedBaseView.delegate = self

            self.view = unwrappedBaseView
            self.baseView?.tableView.delegate = self
            self.baseView?.tableView.dataSource = self
            self.baseView?.tableView.emptyDataSetSource = self
            
            let tableViewCellNib = UINib.init(nibName: "PNNotebooksListTableViewCell", bundle: Bundle.main)
            let tableViewCellNibId = "PNNotebooksListTableViewCell"
            unwrappedBaseView.tableView.register(tableViewCellNib, forCellReuseIdentifier: tableViewCellNibId)
            unwrappedBaseView.tableView.register(UINib.init(nibName: "PNNotebookListViewHeaderCell", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: "PNNotebookListViewHeaderCell")
            
            initInteractors()
        }
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addTableNotificationBlock()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func addTableNotificationBlock() {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return }
        let results = unwrappedRealm.objects(Notebook.self).sorted(byKeyPath: "dateUpdated", ascending: false)
        
        if let unwrappedNotebookListTableView = baseView?.tableView {
            notificationToken = results.addNotificationBlock(unwrappedNotebookListTableView.applyChanges)
        }
    }
    
    internal override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    internal override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     This method sets the `currentNotebook` property of the notes feed view controller. This also dismiss this view controller instance.
     */
    @objc fileprivate func allNotesTapped() {
        createNotebookInteractor?.setNotebook(newNotebook: nil)
        dismiss(animated: true, completion: nil)
    }
    
    /**
     This initiates the `PNCreateNotebookInteractor`.
     */
    fileprivate func initInteractors() {
        let createNotebookPresenter = PNCreateNotebookPresenter.init(presenterOutput: self)
        createNotebookInteractor = PNCreateNotebookInteractor.init(createNotebookPresenter: createNotebookPresenter)
    }
    
}

extension PNNotebooksListViewController: PNNotebooksListViewDelegate, PNNotebookListViewHeaderCellEventHandler {
    /**
     This presents the `UIAlertController` interface for inputting the new `Notebook` name. This also contains the logic when the user saves the new `Notebook` or cancels it.
     */
    internal func addButtonTapped() {
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

extension PNNotebooksListViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return 0 }
        let notebookList = unwrappedRealm.objects(Notebook.self).sorted(byKeyPath: "dateUpdated", ascending: false)
        
        return notebookList.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PNNotebooksListTableViewCell") as? PNNotebooksListTableViewCell {
            guard let unwrappedRealm = PNSharedRealm.realmInstance() else {  return UITableViewCell.init() }
            let notebookList = unwrappedRealm.objects(Notebook.self).sorted(byKeyPath: "dateUpdated", ascending: false)
            cell.setContent(notebook: notebookList[indexPath.row])
            cell.selectionStyle = .none
            
            return cell
        }
        return UITableViewCell.init()
    }
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PNNotebookListViewHeaderCell")  as? PNNotebookListViewHeaderCell {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(allNotesTapped))
            header.addGestureRecognizer(tapRecognizer)
            header.eventHandler = self
            return header
        }
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return }
        let results = unwrappedRealm.objects(Notebook.self).sorted(byKeyPath: "dateUpdated", ascending: false)

        createNotebookInteractor?.setNotebook(newNotebook: results[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}

extension PNNotebooksListViewController: DZNEmptyDataSetSource {
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if scrollView == baseView?.tableView {
            let attributes = [NSFontAttributeName: UIFont.init(name: "Lato", size: 20.0) as Any, NSForegroundColorAttributeName: UIColor.lightGray] as [String: Any]
            return NSAttributedString.init(string: "No Notebook Yet", attributes: attributes)
        }
        return NSAttributedString.init(string: "")
    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if scrollView == baseView?.tableView {
            let attributes = [NSFontAttributeName: UIFont.init(name: "Lato-Light", size: 16.0) as Any, NSForegroundColorAttributeName: UIColor.lightGray] as [String: Any]
            return NSAttributedString.init(string: "Create notebooks to start organizing your notes.", attributes: attributes)
        }
        return NSAttributedString.init(string: "")
    }
}

extension PNNotebooksListViewController: PNCreateNotebookPresenterOutput {
    func update(currentNotebook: Notebook?) {
        output?.update(currentNotebook: currentNotebook)
    }
}
