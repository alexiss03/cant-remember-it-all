//
//  PNNotebookListViewHeaderCell.swift
//  Memo
//
//  Created by Hanet on 7/13/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

protocol PNNotebookListViewHeaderCellEventHandler: VIPEREventHandler {
    func addButtonTapped()
}


class PNNotebookListViewHeaderCell: UITableViewHeaderFooterView {
    weak var eventHandler: PNNotebookListViewHeaderCellEventHandler?
    
    @IBAction private func addButtonTapped(_ sender: Any) {
        eventHandler?.addButtonTapped()
    }
}
