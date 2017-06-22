//
//  PNNotesFeedViewController.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

protocol PNNotesFeedViewProtocol: class {
    var currentNotebook: Notebook? {get set}
}

class PNNotesFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PNNotesFeedViewDelegate, PNNotesFeedViewProtocol {
    let baseView: PNNotesFeedView? = {
        if let view = Bundle.main.loadNibNamed("PNNotesFeedView", owner: self, options: nil)![0] as? PNNotesFeedView {
            return view
        }
        return nil
    }()
    
    var notificationToken: NotificationToken?
    var currentNotebook: Notebook? {
        didSet {
            setPredicate(searchText: searchText, currentNotebook: currentNotebook)
        }
    }
    
    var searchText: String? {
        didSet {
            setPredicate(searchText: searchText, currentNotebook: currentNotebook)
        }
    }
    
    var notebookFilter: NSPredicate = {
        return NSPredicate.init(format: "dateCreated != nil")
    }()
    
    var deleteNoteInteractor: PNDeleteNoteInteractor?

    private func setPredicate(searchText: String?, currentNotebook: Notebook?) {
        if let unwrappedSearchText = searchText, let unwrappedCurrentNotebook = currentNotebook, let notebookName = unwrappedCurrentNotebook.name {
            notebookFilter = NSPredicate.init(format: "notebook == %@ && (body CONTAINS[c] %@ || title CONTAINS[c] %@)", unwrappedCurrentNotebook, unwrappedSearchText, unwrappedSearchText)
            setMenu(notebookName: notebookName)
        } else if let unwrappedSearchText = searchText, currentNotebook == nil {
            notebookFilter = NSPredicate.init(format: "body CONTAINS[c] %@ || title CONTAINS[c] %@", unwrappedSearchText, unwrappedSearchText)
            setMenu(notebookName: "MEMO")
        } else if let unwrappedCurrentNotebook = currentNotebook, let notebookName = unwrappedCurrentNotebook.name, searchText == nil {
            notebookFilter = NSPredicate.init(format: "notebook == %@", unwrappedCurrentNotebook)
            setMenu(notebookName: notebookName)
        } else {
            notebookFilter = NSPredicate.init(format: "dateCreated != nil")
            setMenu(notebookName: "MEMO")
            setNotebookButton()
        }
        
        tableAddNotificationBlock()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let unwrappedBaseView = baseView {
            unwrappedBaseView.frame = self.view.frame
            self.view = unwrappedBaseView
            setMenu()

            unwrappedBaseView.notesListTableView.delegate = self
            unwrappedBaseView.notesListTableView.dataSource = self
            unwrappedBaseView.searchBar.delegate = self

            unwrappedBaseView.delegate = self

            let tableViewCellNib = UINib.init(nibName: "PNNotesFeedTableViewCell", bundle: Bundle.main)
            let tableViewCellNibId = "PNNotesFeedTableViewCell"
            unwrappedBaseView.notesListTableView.register(tableViewCellNib, forCellReuseIdentifier: tableViewCellNibId)
            
            initInteractors()
        }
    }
    
    private func initInteractors() {
        deleteNoteInteractor = PNDeleteNoteInteractor.init()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableAddNotificationBlock()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    private func tableAddNotificationBlock() {
        guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return }
        let results = unwrappedRealm.objects(Note.self).filter(notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
        if let unwrappedNotesListTableView = baseView?.notesListTableView {
            notificationToken = results.addNotificationBlock(unwrappedNotesListTableView.applyChanges)
        }
    }

    // MARK: UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showViewNote()
    }

    // MARK: UITableViewDataSource Methods
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return 0 }
        
        let noteList = unwrappedRealm.objects(Note.self).filter(notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
        return noteList.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PNNotesFeedTableViewCell") as? PNNotesFeedTableViewCell {
            guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return UITableViewCell.init() }
            let noteList = unwrappedRealm.objects(Note.self).filter(notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
            
            cell.setContent(note: noteList[indexPath.row])
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
        weak var weakSelf = self
        let editAction = UITableViewRowAction(style: .default, title: "Move", handler: { (_, _) in
            print("Move tapped")
            
            guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return }
            guard let strongSelf = weakSelf else { return }
            
            let noteList = unwrappedRealm.objects(Note.self).filter(strongSelf.notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
            strongSelf.openMoveNoteNotebookSelector(note: noteList[indexPath.row])
        })
        
        editAction.backgroundColor = PNConstants.blueColor
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (_, _) in
            guard let strongSelf = weakSelf else {
                print("Weak self is nil")
                return
            }
            guard let unwrappedRealm = PNSharedRealm.realmInstance() else {
                print("Realm is nil")
                return
            }

            strongSelf.deleteNoteInteractor?.deleteSelectedNote(indexPath: indexPath, filter: strongSelf.notebookFilter, realm: unwrappedRealm)
//            print("Delete tapped")

//            guard let strongSelf = weakSelf else { return }
            
//            let noteList = unwrappedRealm.objects(Note.self).filter(strongSelf.notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
//            do {
//                try unwrappedRealm.write {
//                    unwrappedRealm.delete(noteList[indexPath.row])
//                }
//            } catch { }
        })
        deleteAction.backgroundColor = PNConstants.redColor
        
        return [deleteAction, editAction]
    }

    func setMenu() {
        let pocketNoteButton = UIButton.init(type: .custom)
        let attributedTitle = NSAttributedString.init(string: "MEMO", attributes: [NSFontAttributeName: UIFont(name: "Lato-Italic", size: 20.0)!, NSForegroundColorAttributeName: UIColor.black])
        pocketNoteButton.setAttributedTitle(attributedTitle, for: .normal)
        pocketNoteButton.addTarget(self, action: #selector(PNNotesFeedViewController.openNotebooks), for: .touchUpInside)
        navigationItem.titleView = pocketNoteButton
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setMenu(notebookName: String) {
        let pocketNoteButton = UIButton.init(type: .custom)
        let attributedTitle = NSAttributedString.init(string: "\(notebookName)", attributes: [NSFontAttributeName: UIFont(name: "Lato-Italic", size: 20.0)!, NSForegroundColorAttributeName: UIColor.black])
        pocketNoteButton.setAttributedTitle(attributedTitle, for: .normal)
        pocketNoteButton.addTarget(self, action: #selector(PNNotesFeedViewController.openNotebooks), for: .touchUpInside)
        navigationItem.titleView = pocketNoteButton
    }

    private func showCreateNote() {
        performSegue(withIdentifier: "TO_CREATE_NOTE", sender: self)
    }

    private func showViewNote() {
        performSegue(withIdentifier: "TO_CREATE_NOTE", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? PNCreateNoteViewController {
            guard let unwrappedRealm = PNSharedRealm.realmInstance() else { return }
        
            let noteList = unwrappedRealm.objects(Note.self).filter(notebookFilter).sorted(byKeyPath: "dateUpdated", ascending: false)
            destinationViewController.notebook = currentNotebook
            
            if let selectedIndexPath = baseView?.notesListTableView.indexPathForSelectedRow {
                destinationViewController.note =  noteList[selectedIndexPath.row]
                baseView?.notesListTableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }

    // MARK: PNNotesFeedViewDelegate Methods
    func addNoteButton() {
        showCreateNote()
    }

    private func setNotebookButton() {
        if currentNotebook != nil {
            let notebookIcon  = UIImage(named: "IconOption")!.withRenderingMode(.alwaysOriginal)
            let notebookButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            notebookButton.setBackgroundImage(notebookIcon, for: .normal)

            let menuIconContainer = UIView(frame: notebookButton.frame)
            menuIconContainer.addSubview(notebookButton)

            let menuNotificationButtonItem = UIBarButtonItem(customView: menuIconContainer)
            navigationItem.rightBarButtonItem = menuNotificationButtonItem
            notebookButton.addTarget(self, action: #selector(PNNotesFeedViewController.showNotebookActions), for:.touchUpInside)
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }

    @objc private func openNotebooks() {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let unwrappedNotebookListViewController = mainStoryboard.instantiateViewController(withIdentifier: "PNNotebooksListViewController") as? PNNotebooksListViewController else {
            print("Notebook List View Controller is nil")
            return
        }
        unwrappedNotebookListViewController.notesFeedDelegate = self
        present(unwrappedNotebookListViewController, animated: true, completion: nil)
    }
    
    private func openMoveNoteNotebookSelector(note: Note) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let unwrappedMoveNoteViewController = mainStoryboard.instantiateViewController(withIdentifier: "PNMoveNoteViewController") as? PNMoveNoteViewController else {
            print("Move Note Controller is nil")
            return
        }
        unwrappedMoveNoteViewController.note = note
        present(unwrappedMoveNoteViewController, animated: true, completion: nil)
    }

    @objc private func showNotebookActions() {
        let alertController = UIAlertController(title: "Notebook Settings", message: "", preferredStyle: .actionSheet)

        let editNotebookAction = UIAlertAction(title: "Edit Notebook", style: .default, handler: { _ -> Void in
            self.editNotebookPopUp()
        })

        weak var weakSelf = self
        let deleteNotebookAction = UIAlertAction(title: "Delete Notebook", style: .default, handler: { (_ : UIAlertAction!) -> Void in
            let strongSelf = weakSelf
            guard let unwrappedRealm = PNSharedRealm.configureDefaultRealm() else { return }
            guard let unwrappedCurrentNotebook = strongSelf?.currentNotebook else {
                print("Current notebook is nil")
                return
            }
            do {
                try unwrappedRealm.write {
                    
                    DispatchQueue.main.async {
                        strongSelf?.viewDidAppear(true)
                        strongSelf?.currentNotebook = nil
                    }
                    
                    unwrappedRealm.delete(unwrappedCurrentNotebook.notes)
                    unwrappedRealm.delete(unwrappedCurrentNotebook)
                }
            } catch {

            }
            
        })
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(editNotebookAction)
        alertController.addAction(deleteNotebookAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func editNotebookPopUp() {
        let alertController = UIAlertController(title: "Edit Notebook", message: "", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print("firstName \(String(describing: firstTextField.text))")
            
            guard let unwrappedRealm = PNSharedRealm.configureDefaultRealm() else { return }
            do {
                weak var weakSelf = self
                try unwrappedRealm.write {
                    let strongSelf = weakSelf
                    if let unwrappedCurrentNotebook = strongSelf?.currentNotebook {
                        unwrappedCurrentNotebook.name = firstTextField.text
                    }
                    
                    if let currentNotebookName = strongSelf?.currentNotebook?.name {
                        strongSelf?.setMenu(notebookName: currentNotebookName)
                    }
                }
            } catch { }
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (_ : UIAlertAction!) -> Void in
        })

        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "New Notebook Name"
        }

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

extension Date {
    /** Returns a timeStamp from a NSDate instance */
    func timeStampFromDate() -> CGFloat {
        return CGFloat(CFAbsoluteTimeGetCurrent())
    }
}

extension UITableView {
    func applyChanges<T>(changes: RealmCollectionChange<T>) {
        switch changes {
        case .initial: reloadData()
            case .update(let _, let deletions, let insertions, let updates):
                let fromRow = { (row: Int) in return IndexPath(row: row, section: 0) }
                
                beginUpdates()
                insertRows(at: insertions.map(fromRow), with: .automatic)
                reloadRows(at: updates.map(fromRow), with: .automatic)
                deleteRows(at: deletions.map(fromRow), with: .automatic)
                endUpdates()
            case .error(let error): fatalError("\(error)")
        }
    }
    
    func applyChangesWithOffset<T>(changes: RealmCollectionChange<T>, offset: Int = 0) {
        switch changes {
            case .initial: reloadData()
            case .update(let _, let deletions, let insertions, let updates):
                let fromRow = { (row: Int) in return IndexPath(row: row, section: 0) }
                
                beginUpdates()
                insertRows(at: insertions.map(fromRow), with: .automatic)
                reloadRows(at: updates.map(fromRow), with: .automatic)
                deleteRows(at: deletions.map(fromRow), with: .automatic)
                endUpdates()
            case .error(let error): fatalError("\(error)")
        }
    }
}

extension PNNotesFeedViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if baseView?.searchBar == searchBar {
            self.searchText = searchText
        }
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if baseView?.searchBar == searchBar {
            self.searchText = searchBar.text
        }
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
