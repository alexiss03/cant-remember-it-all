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

protocol PNNotesFeedViewEventHandler {
    func handleDelete(notebook notebookToDeleted: Notebook)
    func handleDelete(note noteToBeDeleted: Note)
    func handleSearch(text: String?, currentNotebook: Notebook?)
    func handleEditNotebook(newName: String?, notebook: Notebook)
}

protocol PNNotesFeedViewPresenterOutput {
    func update(notes: Results<Note>)
    func setMenu(title: String?)
}

struct PNNotesFeedViewPresenter: PNNotesFeedViewEventHandler {
    private let deleteNotebookInteractor: PNDeleteNotebookInteractorInterface
    private let searchNotebookInteractor: PNSearchNoteInteractorInterface
    private let deleteNoteInteractor: PNDeleteNoteInteractorInterface
    private let editNotebookInteractor: PNEditNotebookInteractorInterface
    
    internal var output: PNNotesFeedViewPresenterOutput?
    
    init(deleteNotebookInteractor: PNDeleteNotebookInteractorInterface, searchNotebookInteractor: PNSearchNoteInteractorInterface, deleteNoteInteractor: PNDeleteNoteInteractorInterface, editNotebookInteractor: PNEditNotebookInteractorInterface) {
        self.deleteNotebookInteractor = deleteNotebookInteractor
        self.searchNotebookInteractor = searchNotebookInteractor
        self.deleteNoteInteractor = deleteNoteInteractor
        self.editNotebookInteractor = editNotebookInteractor
    }
    
    internal func handleDelete(notebook notebookToDeleted: Notebook) {
        deleteNotebookInteractor.delete(notebook: notebookToDeleted)
    }
    
    internal func handleDelete(note noteToBeDeleted: Note) {
        deleteNoteInteractor.delete(selectedNote: noteToBeDeleted)
    }
    
    internal func handleSearch(text: String?, currentNotebook: Notebook?) {
        searchNotebookInteractor.search(text: text, currentNotebook: currentNotebook)
    }
    
    internal func handleEditNotebook(newName: String?, notebook: Notebook) {
        editNotebookInteractor.saveNotebook(newName: newName, notebook: notebook)
    }
}

extension PNNotesFeedViewPresenter: PNSearchNoteInteractorOutput, PNEditNotebookInteractorOutput {
    internal func update(notes: Results<Note>) {
        output?.update(notes: notes)
    }
    
    internal func setMenu(title: String) {
        output?.setMenu(title: title)
    }
}

extension PNNotesFeedViewPresenter: PNDeleteNotebookInteractorOutput {
    internal func setMenuToDefault() {
        output?.setMenu(title: nil)
    }
}

/**
 The `PNNotesFeedViewController` class is a custom view controller for the Notes List module.
 */
class PNNotesFeedViewController: UIViewController, NoteFeedMenu {
    public var AlertAction = UIAlertAction.self
    
    /// A `PNNotesFeedView` instance representing the super view of the current view controller.
    fileprivate let baseView: PNNotesFeedView? = {
        if let view = Bundle.main.loadNibNamed("PNNotesFeedView", owner: self, options: nil)![0] as? PNNotesFeedView {
            return view
        }
        return nil
    }()
    
    /// An option `Notebook` instance representing the current notebook shown to the user.
    fileprivate var currentNotebook: Notebook? {
        didSet {
            self.eventHandler?.handleSearch(text: self.searchText, currentNotebook: self.currentNotebook)
        }
    }
    
    /// An optional `String` value representing the search text inputted by the user.
    fileprivate var searchText: String?
    
//    /// An `NSPredicate` instance representing the predicate filter affected by the value current notebook  and the search text.
//    fileprivate var notebookFilter: NSPredicate = {
//        return NSPredicate.init(format: "dateCreated != nil")
//    }()
    
    /// A `NotificationToken` instance that holds the token for the notification block of the notes list.
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

    internal override func viewDidLoad() {
        super.viewDidLoad()
        if let unwrappedBaseView = baseView {
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
            initInteractors()
        }
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableUpdateNotificationBlock()
    }
    
    fileprivate func tableUpdateNotificationBlock() {
        if let unwrappedTableView = baseView?.notesListTableView {
            notificationToken = notes?.addNotificationBlock(unwrappedTableView.applyChanges)
        }
    }
    
    internal override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    private func initInteractors() {
        if let unwrappedRealm = PNSharedRealm.realmInstance() {
            var deleteNotebookInteractor = PNDeleteNotebookInteractor.init(realm: unwrappedRealm)
            let editNotebookInteractor = PNEditNotebookInteractor.init(realm: unwrappedRealm)
            
            let deleteNoteInteractor = PNDeleteNoteInteractor.init()
            let searchNoteInteractor = PNSearchNoteInteractor.init()
            
            var notesFeedViewPresenter = PNNotesFeedViewPresenter.init(deleteNotebookInteractor: deleteNotebookInteractor, searchNotebookInteractor: searchNoteInteractor, deleteNoteInteractor: deleteNoteInteractor, editNotebookInteractor: editNotebookInteractor)
            notesFeedViewPresenter.output = self
            
            editNotebookInteractor.output = notesFeedViewPresenter
            searchNoteInteractor.output = notesFeedViewPresenter
            deleteNotebookInteractor.output = notesFeedViewPresenter
            
            eventHandler = notesFeedViewPresenter
        }
    }
    
    /**
     Shows the list of notebooks view controller.
     */
    @objc internal func openNotebooks() {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let unwrappedNotebookListViewController = mainStoryboard.instantiateViewController(withIdentifier: "PNNotebooksListViewController") as? PNNotebooksListViewController else {
            print("Notebook List View Controller is nil")
            return
        }
        unwrappedNotebookListViewController.output = self
        present(unwrappedNotebookListViewController, animated: true, completion: nil)
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
        
        present(alertController, animated: true, completion: nil)
    }
    
    internal func saveNotebookAction(alertController: UIAlertController, currentNotebook: Notebook) -> UIAlertAction {
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            self.eventHandler?.handleEditNotebook(newName: firstTextField.text, notebook: currentNotebook)

        })
        return saveAction
    }
    

    @objc public func showNotebookActions(sender: UIButton) {
        let alertController = UIAlertController(title: "Notebook Settings", message: "", preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.delegate = self
        
        let editNotebookAction = AlertAction.init(title: "Edit Notebook", style: .default, handler: { _ -> Void in
            if let currentNotebook = self.currentNotebook {
                self.editNotebookPopUp(currentNotebook: currentNotebook)
            }
        })
        
        let deleteNotebookAction = AlertAction.init(title: "Delete Notebook", style: .default, handler: { (_ : UIAlertAction!) -> Void in
            if let unwrappedCurrentNotebook = self.currentNotebook {
                self.eventHandler?.handleDelete(notebook: unwrappedCurrentNotebook)
            }
        })
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(editNotebookAction)
        alertController.addAction(deleteNotebookAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension PNNotesFeedViewController: PNNotesFeedViewDelegate {
    /**
     Handles the add note button action.
     */
    internal func addNoteButtonTapped() {
        pushCreateNoteView()
    }
    
    internal func openMoveNoteToANotebook(note: Note) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let unwrappedMoveNoteViewController = mainStoryboard.instantiateViewController(withIdentifier: "PNMoveNoteViewController") as? PNMoveNoteViewController else {
            print("Move Note Controller is nil")
            return
        }
        unwrappedMoveNoteViewController.note = note
        present(unwrappedMoveNoteViewController, animated: true, completion: nil)
    }
    
    private func pushCreateNoteView() {
        let createNoteViewController = PNCreateNoteViewController()
        createNoteViewController.notebook = currentNotebook

        navigationController?.pushViewController(createNoteViewController, animated: true)
    }
}

extension PNNotesFeedViewController: UISearchBarDelegate {
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if baseView?.searchBar == searchBar {
            self.searchText = searchText
            self.eventHandler?.handleSearch(text: self.searchText, currentNotebook: self.currentNotebook)
            self.notificationToken?.stop()
        }
    }
    
    internal func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if baseView?.searchBar == searchBar {
            self.searchText = searchBar.text
            self.eventHandler?.handleSearch(text: self.searchText, currentNotebook: self.currentNotebook)
            self.notificationToken?.stop()
            searchBar.showsCancelButton = true
        }
    }
    
    internal func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if baseView?.searchBar == searchBar {
            searchBar.showsCancelButton = false
        }
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension PNNotesFeedViewController: UIPopoverPresentationControllerDelegate {
    public func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.sourceView = self.navigationController?.navigationBar
        popoverPresentationController.sourceRect = (self.navigationController?.navigationBar.frame)!
    }
}

extension PNNotesFeedViewController: PNDeleteNotebookPresenterOutput, PNNotebooksListViewControllerOutput {
    internal func update(currentNotebook: Notebook?) {
        self.currentNotebook = currentNotebook
    }
}

extension PNNotesFeedViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == baseView?.notesListTableView {
            pushToViewNote(selectedIndexPath: indexPath)
        }
    }
    
    private func pushToViewNote(selectedIndexPath: IndexPath) {
        let viewNoteController = PNCreateNoteViewController()
        viewNoteController.note = notes?[selectedIndexPath.row]
        
        navigationController?.pushViewController(viewNoteController, animated: true)
    }
}

extension PNNotesFeedViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unwrappedNotes = notes else {
            return 0
        }
        return unwrappedNotes.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PNNotesFeedTableViewCell") as? PNNotesFeedTableViewCell {
            cell.setContent(note: (notes?[indexPath.row])!)
            cell.selectionStyle = .none
            cell.isEditing = true
            cell.editingAccessoryView = UITableViewCell.init()
            return cell
        }
        return UITableViewCell.init()
    }
    
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        
        } else if editingStyle == .insert {
            
        }
    }
    
    internal func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
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
    
    /**
     Creates an delete action for the table view.
     
     - Parameter indexPath: A `IndexPath` instance receiving the row action.
     */
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
    internal func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if scrollView == baseView?.notesListTableView, currentNotebook !=  NSPredicate.init(format: "dateCreated != nil") {
            return PNFormattedString.formattedString(text: "No Notes Found", fontName: "Lato", fontSize: 20.0)
        } else if scrollView == baseView?.notesListTableView, currentNotebook == nil {
            return PNFormattedString.formattedString(text: "No Notes Yet", fontName: "Lato", fontSize: 20.0)
        } else {
            return PNFormattedString.formattedString(text: "Empty Notebook", fontName: "Lato", fontSize: 20.0)
        }
    }
    
    internal func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if scrollView == baseView?.notesListTableView, currentNotebook !=  NSPredicate.init(format: "dateCreated != nil") {
            return PNFormattedString.formattedString(text: "No notes match your search.", fontName: "Lato-Light", fontSize: 16.0)
        } else if scrollView == baseView?.notesListTableView, currentNotebook == nil {
            return PNFormattedString.formattedString(text: "Start adding notes that you can sync across your iOS devices.", fontName: "Lato-Light", fontSize: 16.0)
        } else {
            return PNFormattedString.formattedString(text: "Start adding notes in this notebook that you can sync across your iOS devices.", fontName: "Lato-Light", fontSize: 16.0)
        }
    }
}

extension PNNotesFeedViewController: PNNotesFeedViewPresenterOutput {
    internal func update(notes: Results<Note>) {
        self.notes = notes
        
        tableUpdateNotificationBlock()
    }
    
    internal func setMenu(title: String?) {
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
}
