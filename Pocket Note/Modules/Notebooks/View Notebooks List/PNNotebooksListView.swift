//
//  PNNewNotebooksView.swift
//  Pocket Note
//
//  Created by Hanet on 5/2/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

protocol PNNotebooksListViewDelegate: class {
    func addButtonTapped()
}

class PNNotebooksListView: UIView {

    weak var delegate: PNNotebooksListViewDelegate?
    @IBOutlet weak var tableView: UITableView!

    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.addButtonTapped()
    }

}
