//
//  PNCreateNoteView.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/30/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

protocol ContentViewContainer {
    weak var contentTextView: UITextView! {get set}
}

class PNCreateNoteView: UIView, ContentViewContainer {
    @IBOutlet weak var contentTextView: UITextView!
    
    public func setContent(note: Note?) {
        contentTextView.text = note?.body
    }
}
