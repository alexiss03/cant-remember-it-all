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

protocol PNNotebooksListViewControllerDelegate: class {
    func update(currentNotebook: Notebook?)
}

/**
 This is the custom `UIViewController` for the Notebook List module.
 */
class PNNotebooksListViewController: UIViewController {
    /// This property contains the alert action to be used. This is for mocking.
    var AlertAction = UIAlertAction.self
    
    /// This `PNNotebooksListView` is set to be the superview of this view controller.
    var baseView: PNNotebooksListView?
    
    fileprivate var eventHandler: PNNotebooksListViewEventHandler?
    fileprivate var notificationToken: NotificationToken?
    weak var delegate: PNNotebooksListViewControllerDelegate?
    
    fileprivate var notebooks: Results<Notebook>? = {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else {
            return nil
        }
        
        let results = unwrappedRealm.objects(Notebook.self).sorted(byKeyPath: "dateUpdated", ascending: false)
        return results
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        initEventHandler()
    }
    
    fileprivate func setUpView() {
        baseView = view as? PNNotebooksListView
        
        guard let unwrappedBaseView = baseView else {
            print("Base view is nil")
            return
        }
        
        unwrappedBaseView.frame = self.view.frame
        
        self.view = unwrappedBaseView
        self.baseView?.tableView.delegate = self
        self.baseView?.tableView.dataSource = self
        self.baseView?.tableView.emptyDataSetSource = self
        
        let tableViewCellNib = UINib.init(nibName: "PNNotebooksListTableViewCell", bundle: Bundle.main)
        let tableViewCellNibId = "PNNotebooksListTableViewCell"
        unwrappedBaseView.tableView.register(tableViewCellNib, forCellReuseIdentifier: tableViewCellNibId)
        unwrappedBaseView.tableView.register(UINib.init(nibName: "PNNotebookListViewHeaderCell", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: "PNNotebookListViewHeaderCell")
    }
    
    /**
     This initiates the `PNCreateNotebookInteractor`.
     */
    fileprivate func initEventHandler() {
        var createNotebookInteractor = PNCreateNotebookInteractor.init()
        let notebooksListPresenter = PNNotebooksListPresenter.init(createNotebookInteractor: createNotebookInteractor, output: self)
        createNotebookInteractor.output = notebooksListPresenter
        eventHandler = notebooksListPresenter
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addTableNotificationBlock()
    }
    
    private func addTableNotificationBlock() {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return }
        let results = unwrappedRealm.objects(Notebook.self).sorted(byKeyPath: "dateUpdated", ascending: false)
        
        if let unwrappedNotebookListTableView = baseView?.tableView {
            notificationToken = results.addNotificationBlock(unwrappedNotebookListTableView.applyChanges)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let unwrappedBaseView = self.baseView {
            unwrappedBaseView.frame = self.view.frame
            self.view = unwrappedBaseView
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PNNotebooksListViewController: PNNotebookListViewHeaderCellEventHandler {
    /**
     This presents the `UIAlertController` interface for inputting the new `Notebook` name. This also contains the logic when the user saves the new `Notebook` or cancels it.
     */
    func addButtonTapped() {
        eventHandler?.handleCreateNote()
    }
    
    /**
     This method sets the `currentNotebook` property of the notes feed view controller. This also dismiss this view controller instance.
     */
    @objc fileprivate func allNotesTapped() {
        delegate?.update(currentNotebook: nil)
        dismiss(animated: true, completion: nil)
    }
}

extension PNNotebooksListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return 0 }
        let notebookList = unwrappedRealm.objects(Notebook.self).sorted(byKeyPath: "dateUpdated", ascending: false)
        
        return notebookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PNNotebooksListTableViewCell") as? PNNotebooksListTableViewCell, let unwrappedNotebook =  notebooks?[indexPath.row] {
            cell.setContent(notebook: unwrappedNotebook)
            cell.selectionStyle = .none
            
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
        
        if let unwrappedNotebook =  notebooks?[indexPath.row] {
            delegate?.update(currentNotebook: unwrappedNotebook)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension PNNotebooksListViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if scrollView == baseView?.tableView {
            return PNFormattedString.formattedString(text: "No Notebook Yet", fontName: "Lato", fontSize: 20.0)
        }
        return NSAttributedString.init(string: "")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if scrollView == baseView?.tableView {
            return PNFormattedString.formattedString(text: "Create notebooks to start organizing your notes", fontName: "Lato-Light", fontSize: 16.0)
        }
        return NSAttributedString.init(string: "")
    }
}

extension PNNotebooksListViewController: PNNotebooksListPresenterOutput {
    func presentAlertController(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }

    func setNotebook(newNotebook: Notebook?) {
        delegate?.update(currentNotebook: newNotebook)
    }
}
