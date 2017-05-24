//
//  PNSideMenuViewController.swift
//  Pocket Note
//
//  Created by Hanet on 4/26/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

class PNSideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let baseView: PNSideMenuView? = {
        if let view = Bundle.main.loadNibNamed("PNSideMenuView", owner: self, options: nil)![0] as? PNSideMenuView {
            return view
        }
        return nil
    }()

    let menuItems = ["PASSCODE", "ARCHIVE"]

    override func viewDidLoad() {
        super.viewDidLoad()

        if let unwrappedBaseView = self.baseView {
            unwrappedBaseView.frame = self.view.frame
            self.view = unwrappedBaseView

            unwrappedBaseView.tableView.delegate = self
            unwrappedBaseView.tableView.dataSource = self
            unwrappedBaseView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: UITableViewDataSource Methods
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
        unwrappedCell.textLabel?.font = UIFont.init(name: "Lato", size: 17)
        unwrappedCell.backgroundColor = UIColor.clear
        return unwrappedCell
    }

}
