//
//  PNNotesFeedView.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/28/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

protocol PNNotesFeedViewDelegate {
    func addNoteButton()
}

class PNNotesFeedView: UIView {
    
    var delegate: PNNotesFeedViewDelegate?
    
    @IBOutlet weak var notesListTableView: UITableView!
    @IBOutlet weak var notesListCollectionView: UICollectionView!
    
    @IBAction func addNoteButton(_ sender: Any) {
        delegate?.addNoteButton()
    }

}
