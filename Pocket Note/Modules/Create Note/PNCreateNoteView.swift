//
//  PNCreateNoteView.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/30/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

/**
 The `ContentViewContainer` protocol exposes the content text view of `PNCreateNoteView`
 */
protocol ContentViewContainer {
    weak var contentTextView: UITextView! {get set}
}

/**
 The `PNCreateNoteView` class is a custom `UIView` for the Create Note and Update Note modules.
 */
class PNCreateNoteView: UIView, ContentViewContainer {
    /// A `UITextView` that contains the content of the note to be updated. This is where the user edits the content of the note.
    @IBOutlet weak var contentTextView: UITextView!
    
    /**
     Sets the content of the view according to a note.
     
     - Parameter note: A note that contains the details to be displayed to the user in this view.
     */
    public func setContent(note: Note?) {
        contentTextView.text = note?.body
    }
}
