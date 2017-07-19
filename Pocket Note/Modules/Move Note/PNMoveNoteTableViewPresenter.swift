//
//  PNMoveNoteTableViewPresenter.swift
//  Memo
//
//  Created by Hanet on 7/19/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

struct PNMoveNoteTableViewPresenter {
    private let presentationContext: UIViewController
    
    internal init(presentationContext: UIViewController) {
        self.presentationContext = presentationContext
    }
    
    internal func dismiss() {
        presentationContext.dismiss(animated: true, completion: nil)
    }
}
