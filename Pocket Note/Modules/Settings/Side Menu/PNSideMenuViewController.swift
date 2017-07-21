//
//  PNSideMenuViewController.swift
//  Pocket Note
//
//  Created by Hanet on 4/26/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

/**
 The `PNSideMenuViewController` class is a custom view controller for the Side Menu module.
 */
class PNSideMenuViewController: UIViewController {
    /// A `PNSideMenuView` instance representing the super view of this view controller.
    fileprivate var baseView: PNSideMenuView? {
        get {
            return view as? PNSideMenuView
        }
    }
    
    /// An array of `String` values displayed as the option for the Side Menu. This temporarily empty.
    fileprivate let menuItems: [String] = []

    internal override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let unwrappedBaseView = self.baseView {
            unwrappedBaseView.frame = self.view.frame
            self.view = unwrappedBaseView
            
            unwrappedBaseView.delegate = self
            unwrappedBaseView.tableView.delegate = self
            unwrappedBaseView.tableView.dataSource = self
            unwrappedBaseView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        }
    }

    internal override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PNSideMenuViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PNSideMenuViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let unwrappedCell = tableView.dequeueReusableCell(withIdentifier: "TableCell") else {
            print("No table cell is dequeued")
            return UITableViewCell()
        }
        
        unwrappedCell.textLabel?.text = menuItems[indexPath.row]
        unwrappedCell.textLabel?.textColor = UIColor.white
        unwrappedCell.textLabel?.font = UIFont.init(name: "Lato", size: 17)
        unwrappedCell.backgroundColor = UIColor.clear
        return unwrappedCell
    }
}

extension PNSideMenuViewController: PNSideMenuViewDelegate {
    /**
     Performs the logout operation when the log out button is tapped.
     */
    internal func logoutButtonTapped() {
        let logoutOperation = PNLogoutUserOperation.init(dismissingContext: self)
        PNOperationQueue.networkOperationQueue.addOperations([logoutOperation], waitUntilFinished: false)
    }
}
