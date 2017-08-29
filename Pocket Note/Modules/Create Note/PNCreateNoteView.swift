//
//  PNCreateNoteView.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/30/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

protocol PNCreateNoteVIPERView: VIPERView {
    func setContentTextView(content: NSAttributedString)
    func setContentTextViewAsFirstResponder()
}

/**
 The `PNCreateNoteView` class is a custom `UIView` for the Create Note and Update Note modules.
 */
class PNCreateNoteView: UIView, PNCreateNoteVIPERView, KeyboardSetting {
    /// A `UITextView` that contains the content of the note to be updated. This is where the user edits the content of the note.
    @IBOutlet weak var contentTextView: UITextView!
    private var textViewKeyboardObserver: TextViewKeyboardObserver?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addDoneButton(view: self, inputView: contentTextView)
        
        textViewKeyboardObserver = TextViewKeyboardObserver.init(notesTextView: contentTextView)
        textViewKeyboardObserver?.startObserving()
        
        let keyboardToolbar = Bundle.main.loadNibNamed("PNCreateNoteToolbarView", owner: self, options: nil)?[0] as? UIView
        contentTextView.inputAccessoryView = keyboardToolbar
    }
    
    /**
     Sets the content of the content text view.
    
    - Parameter content: A string value that is the content of a note to be displayed.
    */
    public func setContentTextView(content: NSAttributedString) {
        contentTextView.attributedText = content
    }
    
    func setContentTextViewAsFirstResponder() {
        contentTextView.becomeFirstResponder()
    }
}
