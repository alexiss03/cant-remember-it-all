//
//  PNNewNotebooksViewController.swift
//  Pocket Note
//
//  Created by Hanet on 5/2/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

class PNNotebooksListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let baseView: PNNotebooksListView? = {
        if let view = Bundle.main.loadNibNamed("PNNotebooksListView", owner: self, options: nil)![0] as? PNNotebooksListView {
            return view
        }
        return nil
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let unwrappedBaseView = baseView {
            unwrappedBaseView.frame = self.view.frame
            unwrappedBaseView.delegate = self

            self.view = unwrappedBaseView
            self.baseView?.tableView.delegate = self
            self.baseView?.tableView.dataSource = self

            let tableViewCellNib = UINib.init(nibName: "PNNotesFeedTableViewCell", bundle: Bundle.main)
            let tableViewCellNibId = "PNNotesFeedTableViewCell"
            unwrappedBaseView.tableView.register(tableViewCellNib, forCellReuseIdentifier: tableViewCellNibId)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PNNotesFeedTableViewCell")
        return cell!
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
        dismiss(animated: true, completion: nil)
    }
}

extension PNNotebooksListViewController: PNNotebooksListViewDelegate {
    func addButtonTapped() {
        let alertController = UIAlertController(title: "New Notebook", message: "", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print("firstName \(String(describing: firstTextField.text))")
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
