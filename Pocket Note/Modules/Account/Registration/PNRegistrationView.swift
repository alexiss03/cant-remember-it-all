//
//  PNRegistrationView.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

protocol PNRegistrationViewDelegate: class {
    func signUpButtonTapped()
}

class PNRegistrationView: UIView {
    weak var delegate: PNRegistrationViewDelegate?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!

    @IBAction func signUpButtonTapped(_ sender: Any) {
        delegate?.signUpButtonTapped()
    }

}
