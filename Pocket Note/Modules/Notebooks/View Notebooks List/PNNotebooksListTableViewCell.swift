//
//  PNNotebooksListTableViewCell.swift
//  Memo
//
//  Created by Hanet on 6/14/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

class PNNotebooksListTableViewCell: UITableViewCell {

    @IBOutlet weak var notebookNameLabel: UILabel!
    @IBOutlet weak var noteBookItemCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    internal func setContent(notebook: Notebook) {
        notebookNameLabel.text = notebook.name
        if notebook.notes.count == 1 {
            noteBookItemCount.text = "\(notebook.notes.count) note"
        } else if notebook.notes.count > 1 {
            noteBookItemCount.text = "\(notebook.notes.count) notes"
        } else {
            noteBookItemCount.text = ""
        }
    }
    
}
