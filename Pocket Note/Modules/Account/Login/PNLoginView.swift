//
//  PNLoginView.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

protocol PNLoginViewDelegate {
    func loginButtonTapped()
    func signUpHereButtonTapped()
}

class PNLoginView: UIView {
    
    var delegate: PNLoginViewDelegate?
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        delegate?.loginButtonTapped()
    }
    
    @IBAction func signUpHereButtonTapped(_ sender: Any) {
        delegate?.signUpHereButtonTapped()
    }

}
