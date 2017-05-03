//
//  PNRegistrationView.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

protocol PNRegistrationViewDelegate {
    func signUpButtonTapped()
}

class PNRegistrationView: UIView {

    var delegate: PNRegistrationViewDelegate?
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        delegate?.signUpButtonTapped()
    }
    
}
