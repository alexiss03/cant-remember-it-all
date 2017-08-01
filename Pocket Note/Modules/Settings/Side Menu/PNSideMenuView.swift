//
//  PNMenuSideView.swift
//  Pocket Note
//
//  Created by Hanet on 4/26/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

/**
 The `PNSideMenuViewDelegate` protocol exposes the actions performed on `PNSideMenuView`.
 */
protocol PNSideMenuViewDelegate: class {
    func logoutButtonTapped()
}

/**
 The `PNSideMenuView` class is a custom view for the Side Menu module.
 */
class PNSideMenuView: UIView {
    /// A `PNSideMenuViewDelegate`instance receiving the actions declared in `PNSideMenuViewDelegate`.
    weak var delegate: PNSideMenuViewDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var usernameLabel: UILabel!
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        delegate?.logoutButtonTapped()
    }
    
    func hideLogoutButton() {
        logoutButton.isHidden = true
    }
    
    func setUsername(_ username: String) {
        usernameLabel.isHidden = false
        usernameLabel.text = username
    }
}
