//
//  PNNotesFeedTableViewCell.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

/**
 The `PNNotesFeedTableViewCell` class representing a custom view for the tabie view cell in the Note List module.
 */
class PNNotesFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var markedIconImageView: UIImageView!
    
    /**
     Sets the view's content given a note. 
     
     - Parameter note: A `Note` instance containing the content to be displayed.
    */
    public func setContent(note: Note) {
        descriptionLabel.text = note.body
        titleLabel.text = note.body
        dateLabel.text = note.dateUpdated?.displayString()
        if note.notebook != nil {
            markedIconImageView.isHidden = false
        } else {
            markedIconImageView.isHidden = true
        }
    }
}
