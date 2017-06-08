//
//  PNRegistrationView.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

/**
 This class represents the Registration User Interface backbone.
 */
class PNRegistrationView: UIView, PNRegistrationViewProtocol {
    /// This is a weak reference to the delegate for `PNRegistrationViewDelegate`.
    weak var delegate: PNRegistrationViewDelegate?

    /// This is the text field where the user inputs the email to be registered.
    @IBOutlet weak var emailTextField: UITextField!
    /// This is the text field where the user inputs the password for the email to be registered.
    @IBOutlet weak var passwordTextField: UITextField!

    /// This is the container where email-related error is presented.
    @IBOutlet weak var emailErrorLabel: UILabel!
    /// This is the container where password-related error is shown.
    @IBOutlet weak var passwordErrorLabel: UILabel!

    /** This method where the receives the touch from the sign up button. This calls the delegate's `signUpButtonTapped`
        - Paramter sender: The sender of the action which is the sign up button
    */
    @IBAction func signUpButtonTapped(_ sender: Any) {
        delegate?.signUpButtonTapped()
    }

}
