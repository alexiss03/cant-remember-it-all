//
//  PNLoginView.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

protocol PNLoginViewDelegate: class {
    func loginButtonTapped()
    func signUpHereButtonTapped()
}

protocol PNLoginViewProtocol: class {
    var emailErrorLabel: UILabel! {get set}
    var passwordErrorLabel: UILabel! {get set}
}

class PNLoginView: UIView, PNLoginViewProtocol {
    weak var delegate: PNLoginViewDelegate?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!

    @IBAction func loginButtonTapped(_ sender: Any) {
        delegate?.loginButtonTapped()
    }

    @IBAction func signUpHereButtonTapped(_ sender: Any) {
        delegate?.signUpHereButtonTapped()
    }
    
}
