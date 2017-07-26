//
//  PNNotesFeedViewController.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift
import SlideMenuControllerSwift
import DZNEmptyDataSet

protocol PNNotesFeedViewPresenterOutput {
    func update(notes: Results<Note>)
    func setMenu(title: String?)
}

class PNNotesFeedViewController: UIViewController {
    public var AlertAction = UIAlertAction.self
    
    fileprivate let baseView: PNNotesFeedView? = {
        if let view = Bundle.main.loadNibNamed("PNNotesFeedView", owner: self, options: nil)![0] as? PNNotesFeedView {
            return view
        }
        return nil
    }()
    
    fileprivate var currentNotebook: Notebook?
    
    fileprivate var notificationToken: NotificationToken?
    fileprivate var eventHandler: PNNotesFeedViewEventHandler?
    
    fileprivate var notes: Results<Note>? = {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else {
            return nil
        }
        
        let initialFilter = NSPredicate.init(format: "dateCreated != nil")
        let results = unwrappedRealm.objects(Note.self).filter(initialFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
        return results
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        initEventHandler()
    }
    
    fileprivate func setUpView() {
        guard let unwrappedBaseView = baseView else {
            print("Base view is nil")
            return
        }
        
        unwrappedBaseView.frame = self.view.frame
        view = unwrappedBaseView
        
        unwrappedBaseView.searchBar.delegate = self
        unwrappedBaseView.delegate = self
        unwrappedBaseView.setContent()
        
        unwrappedBaseView.notesListTableView.delegate = self
        unwrappedBaseView.notesListTableView.dataSource = self
        unwrappedBaseView.notesListTableView.rowHeight = UITableViewAutomaticDimension
        unwrappedBaseView.notesListTableView.estimatedRowHeight = 75
        unwrappedBaseView.notesListTableView.emptyDataSetSource = self
        
        let tableViewCellNib = UINib.init(nibName: "PNNotesFeedTableViewCell", bundle: Bundle.main)
        let tableViewCellNibId = "PNNotesFeedTableViewCell"
        unwrappedBaseView.notesListTableView.register(tableViewCellNib, forCellReuseIdentifier: tableViewCellNibId)
        
        setMenu(title: "MENU")
    }
    
    fileprivate func initEventHandler() {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else {
            print("Realm is nil")
            return
        }
        
        let deleteNotebookInteractor = PNDeleteNotebookInteractor.init(realm: unwrappedRealm)
        let editNotebookInteractor = PNEditNotebookInteractor.init(realm: unwrappedRealm)
        
        let deleteNoteInteractor = PNDeleteNoteInteractor.init()
        let searchNoteInteractor = PNSearchNoteInteractor.init()
        
        let notesFeedViewPresenter = PNNotesFeedViewPresenter.init(deleteNotebookInteractor: deleteNotebookInteractor, searchNotebookInteractor: searchNoteInteractor, deleteNoteInteractor: deleteNoteInteractor, editNotebookInteractor: editNotebookInteractor)
        notesFeedViewPresenter.output = self
        
        editNotebookInteractor.output = notesFeedViewPresenter
        searchNoteInteractor.output = notesFeedViewPresenter
        deleteNotebookInteractor.output = notesFeedViewPresenter
        
        eventHandler = notesFeedViewPresenter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableUpdateNotificationBlock()
    }
    
    fileprivate func tableUpdateNotificationBlock() {
        if let unwrappedTableView = baseView?.notesListTableView {
            notificationToken = notes?.addNotificationBlock(unwrappedTableView.applyChanges)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
}

extension PNNotesFeedViewController: NoteFeedMenu {
    @objc func showNotebookActions(sender: UIButton) {
        let alertController = UIAlertController(title: "Notebook Settings", message: "", preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.delegate = self
        
        let editNotebookAction = AlertAction.init(title: "Edit Notebook", style: .default, handler: { [weak self] _ -> Void in
            if let currentNotebook = self?.currentNotebook {
                self?.editNotebookPopUp(currentNotebook: currentNotebook)
            }
        })
        
        let deleteNotebookAction = AlertAction.init(title: "Delete Notebook", style: .default, handler: { [weak self] (_ : UIAlertAction!) -> Void in
            if let unwrappedCurrentNotebook = self?.currentNotebook {
                self?.eventHandler?.handleDelete(notebook: unwrappedCurrentNotebook)
            }
        })
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(editNotebookAction)
        alertController.addAction(deleteNotebookAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func editNotebookPopUp(currentNotebook: Notebook) {
        let alertController = UIAlertController(title: "Edit Notebook", message: "", preferredStyle: .alert)
        
        let saveAction = saveNotebookAction(alertController: alertController, currentNotebook: currentNotebook)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "New Notebook Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func saveNotebookAction(alertController: UIAlertController, currentNotebook: Notebook) -> UIAlertAction {
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [weak self]_ -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            self?.eventHandler?.handleEditNotebook(newName: firstTextField.text, notebook: currentNotebook)
            
        })
        return saveAction
    }
}

extension PNNotesFeedViewController: PNNotesFeedViewDelegate {
    /**
     Handles the add note button action.
     */
    func addNoteButtonTapped() {
        pushCreateNoteView()
    }
    
    func openMoveNoteToANotebook(note: Note) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let unwrappedMoveNoteViewController = mainStoryboard.instantiateViewController(withIdentifier: "PNMoveNoteViewController") as? PNMoveNoteViewController else {
            print("Move Note Controller is nil")
            return
        }
        unwrappedMoveNoteViewController.note = note
        present(unwrappedMoveNoteViewController, animated: true, completion: nil)
    }
    
    fileprivate func pushCreateNoteView() {
        let createNoteViewController = PNCreateNoteViewController()
        createNoteViewController.notebook = currentNotebook

        navigationController?.pushViewController(createNoteViewController, animated: true)
    }
}

extension PNNotesFeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if baseView?.searchBar == searchBar {
            self.eventHandler?.handleSearch(text: searchBar.text, currentNotebook: self.currentNotebook)
            self.notificationToken?.stop()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if baseView?.searchBar == searchBar {

            self.eventHandler?.handleSearch(text: searchBar.text, currentNotebook: self.currentNotebook)
            self.notificationToken?.stop()
            searchBar.showsCancelButton = true
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if baseView?.searchBar == searchBar {
            searchBar.showsCancelButton = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension PNNotesFeedViewController: UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.sourceView = self.navigationController?.navigationBar
        popoverPresentationController.sourceRect = (self.navigationController?.navigationBar.frame)!
    }
}

extension PNNotesFeedViewController: PNDeleteNotebookPresenterOutput, PNNotebooksListViewControllerOutput {
    func update(currentNotebook: Notebook?) {
        self.currentNotebook = currentNotebook
        eventHandler?.handleSearch(text: baseView?.searchBar.text, currentNotebook: currentNotebook)
        
    }
}

extension PNNotesFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == baseView?.notesListTableView {
            pushToViewNote(selectedIndexPath: indexPath)
        }
    }
    
    fileprivate func pushToViewNote(selectedIndexPath: IndexPath) {
        let viewNoteController = PNCreateNoteViewController()
        viewNoteController.note = notes?[selectedIndexPath.row]
        
        navigationController?.pushViewController(viewNoteController, animated: true)
    }
}

extension PNNotesFeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unwrappedNotes = notes else {
            return 0
        }
        return unwrappedNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PNNotesFeedTableViewCell") as? PNNotesFeedTableViewCell {
            cell.setContent(note: (notes?[indexPath.row])!)
            cell.selectionStyle = .none
            cell.isEditing = true
            cell.editingAccessoryView = UITableViewCell.init()
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        
        } else if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = editRowAction(indexPath: indexPath)
        let deleteAction = deleteRowAction(indexPath: indexPath)
        
        return [deleteAction, editAction]
    }
    
    fileprivate func editRowAction(indexPath: IndexPath) -> UITableViewRowAction {
        let editAction = UITableViewRowAction(style: .default, title: "Move", handler: { (_, _) in
            print("Move tapped")
            
            guard let unwrappedNotes = self.notes else { return }
            self.openMoveNoteToANotebook(note: unwrappedNotes[indexPath.row])
        })
        editAction.backgroundColor = PNConstants.blueColor
        
        return editAction
    }
    
    fileprivate func deleteRowAction(indexPath: IndexPath) -> UITableViewRowAction {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (_, _) in
            if let noteToBeDeleted = self.notes?[indexPath.row] {
                self.eventHandler?.handleDelete(note: noteToBeDeleted)
            }
        })
        deleteAction.backgroundColor = PNConstants.redColor
        return deleteAction
    }
}

extension PNNotesFeedViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if scrollView == baseView?.notesListTableView, baseView?.searchBar.text?.characters.count != 0 {
            return PNFormattedString.formattedString(text: "No Notes Found", fontName: "Lato", fontSize: 20.0)
        } else if scrollView == baseView?.notesListTableView, currentNotebook == nil {
            return PNFormattedString.formattedString(text: "No Notes Yet", fontName: "Lato", fontSize: 20.0)
        } else {
            return PNFormattedString.formattedString(text: "Empty Notebook", fontName: "Lato", fontSize: 20.0)
        }
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if scrollView == baseView?.notesListTableView, baseView?.searchBar.text?.characters.count != 0 {
            return PNFormattedString.formattedString(text: "No notes match your search.", fontName: "Lato-Light", fontSize: 16.0)
        } else if scrollView == baseView?.notesListTableView, currentNotebook == nil {
            return PNFormattedString.formattedString(text: "Start adding notes that you can sync across your iOS devices.", fontName: "Lato-Light", fontSize: 16.0)
        } else {
            return PNFormattedString.formattedString(text: "Start adding notes in this notebook that you can sync across your iOS devices.", fontName: "Lato-Light", fontSize: 16.0)
        }
    }
}

extension PNNotesFeedViewController: PNNotesFeedViewPresenterOutput {
    func update(notes: Results<Note>) {
        self.notes = notes
        
        tableUpdateNotificationBlock()
    }
    
    func setMenu(title: String?) {
        guard let slideController = self.parent else {
            return
        }
        
        if let unwrappedTitle = title {
            setMenu(title: unwrappedTitle, target: self, action: #selector(self.openNotebooks), viewController: self, slideController: slideController)
            setNotebookButton(target: self, currentNotebook: currentNotebook, navigationItem: navigationItem)
        } else {
            setMenu(title: "MEMO", target: self, action: #selector(self.openNotebooks), viewController: self, slideController: slideController)
            setNotebookButton(target: self, currentNotebook: nil, navigationItem: navigationItem)
        }
    }
    
    @objc func openNotebooks() {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let unwrappedNotebookListViewController = mainStoryboard.instantiateViewController(withIdentifier: "PNNotebooksListViewController") as? PNNotebooksListViewController else {
            print("Notebook List View Controller is nil")
            return
        }
        unwrappedNotebookListViewController.output = self
        present(unwrappedNotebookListViewController, animated: true, completion: nil)
    }
}
