//
//  UITableView.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

extension UITableView {
    func applyChanges<T>(changes: RealmCollectionChange<T>) {
        switch changes {
        case .initial: reloadData()
        case .update(_, let deletions, let insertions, let updates):
            let fromRow = { (row: Int) in return IndexPath(row: row, section: 0) }
            
            beginUpdates()
            insertRows(at: insertions.map(fromRow), with: .automatic)
            reloadRows(at: updates.map(fromRow), with: .automatic)
            deleteRows(at: deletions.map(fromRow), with: .automatic)
            endUpdates()
        case .error(let error): fatalError("\(error)")
        }
    }
    
    func applyChangesWithOffset<T>(changes: RealmCollectionChange<T>, offset: Int = 0) {
        switch changes {
        case .initial: reloadData()
        case .update(_, let deletions, let insertions, let updates):
            let fromRow = { (row: Int) in return IndexPath(row: row, section: 0) }
            
            beginUpdates()
            insertRows(at: insertions.map(fromRow), with: .automatic)
            reloadRows(at: updates.map(fromRow), with: .automatic)
            deleteRows(at: deletions.map(fromRow), with: .automatic)
            endUpdates()
        case .error(let error): fatalError("\(error)")
        }
    }
}
