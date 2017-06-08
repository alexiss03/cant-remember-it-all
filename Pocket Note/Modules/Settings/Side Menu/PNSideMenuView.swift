//
//  PNMenuSideView.swift
//  Pocket Note
//
//  Created by Hanet on 4/26/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

protocol PNSideMenuViewDelegate: class {
    func logoutButtonTapped()
}

class PNSideMenuView: UIView {

    weak var delegate: PNSideMenuViewDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func logoutButtonTapped(_ sender: Any) {
        delegate?.logoutButtonTapped()
    }
}
