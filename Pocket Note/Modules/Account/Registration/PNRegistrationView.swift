//
//  PNRegistrationView.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

protocol PNRegistrationVIPERView {
    func setEmailErrorLabel(errorMessage: String)
    func setPasswordErrorLabel(errorMessage: String)
}

/**
 This class represents the Registration User Interface backbone.
 */
class PNRegistrationView: UIView, PNRegistrationVIPERView {
    /// This is a weak reference to the delegate for `PNRegistrationViewDelegate`.
    var eventHandler: PNRegistrationVIPEREventHandler?

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
        eventHandler?.signUp(emailText: self.emailTextField.text, passwordText: self.passwordTextField.text)
    }
    
    func setPasswordErrorLabel(errorMessage: String) {
        DispatchQueue.main.async {
            self.passwordErrorLabel.text = errorMessage
        }
    }
    
    func setEmailErrorLabel(errorMessage: String) {
        DispatchQueue.main.async {
            self.emailErrorLabel.text = errorMessage
        }
    }

}
