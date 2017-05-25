//
//  PNNotesFeedViewController.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

class PNNotesFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PNNotesFeedViewDelegate {

    let baseView: PNNotesFeedView? = {
        if let view = Bundle.main.loadNibNamed("PNNotesFeedView", owner: self, options: nil)![0] as? PNNotesFeedView {
            return view
        }
        return nil
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let unwrappedBaseView = baseView {
            unwrappedBaseView.frame = self.view.frame
            self.view = unwrappedBaseView
            self.setMenu()

            unwrappedBaseView.notesListTableView.delegate = self
            unwrappedBaseView.notesListTableView.dataSource = self

            unwrappedBaseView.delegate = self

            let tableViewCellNib = UINib.init(nibName: "PNNotesFeedTableViewCell", bundle: Bundle.main)
            let tableViewCellNibId = "PNNotesFeedTableViewCell"
            unwrappedBaseView.notesListTableView.register(tableViewCellNib, forCellReuseIdentifier: tableViewCellNibId)

            setNotebookButton()
        }
    }

    // MARK: UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showViewNote()
    }

    // MARK: UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PNNotesFeedTableViewCell")
        return cell!
    }

    func setMenu() {
        let pocketNoteButton = UIButton.init(type: .custom)
        pocketNoteButton.setTitle("Pocket Note", for: .normal)
        pocketNoteButton.addTarget(self, action: #selector(PNNotesFeedViewController.openNotebooks), for: .touchUpInside)
        self.navigationItem.titleView = pocketNoteButton
    }

    private func showCreateNote() {
        self.performSegue(withIdentifier: "TO_CREATE_NOTE", sender: self)
    }

    func showViewNote() {
        self.performSegue(withIdentifier: "TO_CREATE_NOTE", sender: self)
    }

    // MARK: PNNotesFeedViewDelegate Methods
    func addNoteButton() {
        showCreateNote()
    }

    private func setNotebookButton() {
        let notebookIcon  = UIImage(named: "DrawerNotification")!.withRenderingMode(.alwaysOriginal)
        let notebookButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        notebookButton.setBackgroundImage(notebookIcon, for: .normal)

        let menuIconContainer = UIView(frame: notebookButton.frame)
        menuIconContainer.addSubview(notebookButton)

        let menuNotificationButtonItem = UIBarButtonItem(customView: menuIconContainer)
        self.navigationItem.rightBarButtonItem = menuNotificationButtonItem
        notebookButton.addTarget(self, action: #selector(PNNotesFeedViewController.showNotebookActions), for:.touchUpInside)
    }

    @objc private func openNotebooks() {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let unwrappedNotebookListViewController = mainStoryboard.instantiateViewController(withIdentifier: "PNNotebooksListViewController") as? PNNotebooksListViewController else {
            print("Notebook List View Controller is nil")
            return
        }

        self.present(unwrappedNotebookListViewController, animated: true, completion: nil)
    }

    @objc private func showNotebookActions() {
        let alertController = UIAlertController(title: "Notebook Settings", message: "", preferredStyle: .actionSheet)

        let editNotebookAction = UIAlertAction(title: "Edit Notebook", style: .default, handler: { _ -> Void in
            self.editNotebookPopUp()
        })

        let deleteNotebookAction = UIAlertAction(title: "Delete Notebook", style: .default, handler: { (_ : UIAlertAction!) -> Void in
        })

        alertController.addAction(editNotebookAction)
        alertController.addAction(deleteNotebookAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func editNotebookPopUp() {
        let alertController = UIAlertController(title: "Edit Notebook", message: "", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print("firstName \(String(describing: firstTextField.text))")
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
