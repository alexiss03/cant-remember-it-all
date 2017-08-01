//
//  PNSideMenuViewController.swift
//  Pocket Note
//
//  Created by Hanet on 4/26/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

protocol PNSideMenuViewControllerDelegate: class {
    func didTapLogout()
    func didTapIntegrateAccount()
}
/**
 The `PNSideMenuViewController` class is a custom view controller for the Side Menu module.
 */
class PNSideMenuViewController: UIViewController {
    /// A `PNSideMenuView` instance representing the super view of this view controller.
    fileprivate var baseView: PNSideMenuView?
    
    /// An array of `String` values displayed as the option for the Side Menu. This temporarily empty.
    fileprivate var menuItems: [String] = []
    weak var delegate: PNSideMenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        baseView = view as? PNSideMenuView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let baseView = self.baseView  else {
            print("Base view is nil")
            return
        }
        
        baseView.frame = self.view.frame
        self.view = baseView
        
        baseView.delegate = self
        baseView.tableView.delegate = self
        baseView.tableView.dataSource = self
        baseView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
  
        guard let realm = PNSharedRealm.realmInstance() else {
            print("Realm is nil")
            return
        }
        
        if let account = realm.objects(Account.self).first, let username = account.username {
            baseView.setUsername(username)
        }
        
        if SyncUser.current == nil {
            menuItems = ["INTEGRATE EXISTING ACCOUNT"]
            baseView.hideLogoutButton()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PNSideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0, indexPath.row == 0 {
            delegate?.didTapIntegrateAccount()
        }
    }
}

extension PNSideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let unwrappedCell = tableView.dequeueReusableCell(withIdentifier: "TableCell") else {
            print("No table cell is dequeued")
            return UITableViewCell()
        }
        
        unwrappedCell.textLabel?.text = menuItems[indexPath.row]
        unwrappedCell.textLabel?.textColor = UIColor.white
        unwrappedCell.textLabel?.font = UIFont.init(name: "Lato", size: 15)
        unwrappedCell.backgroundColor = UIColor.clear
        return unwrappedCell
    }
}

extension PNSideMenuViewController: PNSideMenuViewDelegate {
    /**
     Performs the logout operation when the log out button is tapped.
     */
    func logoutButtonTapped() {
        let logoutOperation = PNLogoutUserOperation.init()
        PNOperationQueue.networkOperationQueue.addOperations([logoutOperation], waitUntilFinished: false)
        delegate?.didTapLogout()
    }
}
