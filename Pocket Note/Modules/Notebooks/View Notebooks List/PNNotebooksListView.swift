//
//  PNNewNotebooksView.swift
//  Pocket Note
//
//  Created by Hanet on 5/2/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

/**
 This is the delegate protocol that contains the action from the `PNNotebooksListView`
 */
protocol PNNotebooksListViewDelegate: class {
    func addButtonTapped()
}

/**
 This is a custom subclass of `UIView`
 */
class PNNotebooksListView: UIView {
    /// This is the delegate that handles the action from this view.
    weak var delegate: PNNotebooksListViewDelegate?
    /// This is the `UITableView` that contains the list of `Notebook`s.
    @IBOutlet weak var tableView: UITableView!
    ///This is the `UIButton` that is triggered when adding a new `Notebook`.
    @IBOutlet weak var addButton: UIButton!

    /**
     This is the action method when the add `Notebook` button is tapped.
     
     - Parameter sender: This is the sender of the action, which is the `addButton`.
    */
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.addButtonTapped()
    }

}
