//
//  PNNotesFeedTableViewCell.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

class PNNotesFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var markedIconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
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

extension Date {
    func displayString() -> String {
        let dateFormatter = DateFormatter()
        let date = self
        dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"

        return dateFormatter.string(from: date)
    }
}
