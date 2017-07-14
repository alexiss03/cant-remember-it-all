//
//  TextViewKeyboardObserver.swift
//  Memo
//
//  Created by Hanet on 7/11/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

final class TextViewKeyboardObserver {
    var notesTextView: UITextView
    var bottomOffset: UIView?
    
     init(notesTextView: UITextView, bottomOffset: UIView? = nil) {
        self.notesTextView = notesTextView
        self.bottomOffset = bottomOffset
    }
    
    internal func startObserving() {
        NotificationCenter.default.addObserver(self, selector: #selector(TextViewKeyboardObserver.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TextViewKeyboardObserver.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect {
            var contentInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            
            if let unwrappedBottomOffset = bottomOffset {
                contentInsets.bottom = keyboardSize.height - unwrappedBottomOffset.frame.height
            }

            UIView.animate(withDuration: 0.25, animations: {
                self.notesTextView.contentInset = contentInsets
                self.notesTextView.scrollIndicatorInsets = contentInsets
            })
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.notesTextView.contentInset = contentInsets
            self.notesTextView.scrollIndicatorInsets = contentInsets
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
