//
//  PNNotesFeedView.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

/**
 The `PNNotesFeedViewDelegate` protocol handles the action from `PNNotesFeedView`.
 */
protocol PNNotesFeedViewDelegate: class {
    func addNoteButtonTapped()
}

/**
 The `PNNotesFeedView` class is custom view for the Notes List module.
 */
class PNNotesFeedView: UIView {
    /// A `PNNotesFeedViewDelegate` instance representing the object receiver of the delegate methods.
    weak var delegate: PNNotesFeedViewDelegate?

    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var notesListTableView: UITableView!
    @IBOutlet weak var notesListCollectionView: UICollectionView!

    /**
     Triggers the addNoteButtonTapped delegate method.
     */
    @IBAction func addNoteButtonTapped(_ sender: Any) {
        delegate?.addNoteButtonTapped()
    }
    
    func setContent() { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addNoteButton.contentMode = .center
    }

}
