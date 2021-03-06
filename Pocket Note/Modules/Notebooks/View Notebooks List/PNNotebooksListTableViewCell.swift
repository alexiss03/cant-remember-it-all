//
//  PNNotebooksListTableViewCell.swift
//  Memo
//
//  Created by Hanet on 6/14/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

/**
 This is a custom `UIView` for the table view cell in notebook list.
 */
final class PNNotebooksListTableViewCell: UITableViewCell {
    /// A `UIView` that holds the name of the `Notebook`.
    @IBOutlet weak var notebookNameLabel: UILabel!
    /// A `UILabel` that contains the notes count in a `Notebook`.
    @IBOutlet weak var noteBookItemCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /**
    This method sets the content of this `UIView` from a `Notebook` instance.
     
    - Parameter notebook: This is the `Notebook` instance that contains the details to be displayed.
     */
    func setContent(notebook: Notebook) {
        notebookNameLabel.text = notebook.name
        if notebook.notes.count == 1 {
            noteBookItemCount.text = "\(notebook.notes.count) note"
        } else {
            noteBookItemCount.text = "\(notebook.notes.count) notes"
        }
    }
    
}
