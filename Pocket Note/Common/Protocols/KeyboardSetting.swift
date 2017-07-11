//
//  KeyboardSetting.swift
//  Memo
//
//  Created by Hanet on 7/11/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

protocol KeyboardSetting: class {
    func addDoneButton(view: UIView, inputView: UITextView)
    func addDoneButton(view: UIView, inputView: UITextField)
    func addDoneButton(view: UIView, inputView: UISearchBar)
}

extension KeyboardSetting {
    internal func addDoneButton(view: UIView, inputView: UITextView) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        inputView.inputAccessoryView = keyboardToolbar
    }
    
    internal func addDoneButton(view: UIView, inputView: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        inputView.inputAccessoryView = keyboardToolbar
    }
    
    internal func addDoneButton(view: UIView, inputView: UISearchBar) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        inputView.inputAccessoryView = keyboardToolbar
    }
}
