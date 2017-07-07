//
//  PNLoginView.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
/**
 The `PNLoginVIPERView` protocol is a VIEW VIPER protocol that allows modification in the view's UI.
 */
public protocol PNLoginVIPERView {
    func setEmailErrorLabel(errorMessage: String?)
    func setPasswordErrorLabel(errorMessage: String?)
}

/**
 This class is the custom class for `PNLoginView.xib`. It references the outlets for that nib file.
 */
class PNLoginView: UIView, PNLoginVIPERView, VIPERView {
    // A `PNLoginViewEventHandler` conforming object that handles all the actions from this view.
    var eventHandler: PNLoginViewEventHandler?
    
    // This text field is where the user inputs the email to be logged in.
    @IBOutlet weak var emailTextField: UITextField!
    // This text field is where the user input the password of the account to be logged in.
    @IBOutlet weak var passwordTextField: UITextField!
    
    // This label shows the email-related errors
    @IBOutlet weak var emailErrorLabel: UILabel!
    // This label shows password-related errors
    @IBOutlet weak var passwordErrorLabel: UILabel!

    /**
     This method is the action receiver of the touch inside the log in button.
     
     - Parameter sender: This is the sender of the action, which is the log in button.
     */
    @IBAction func loginButtonTapped(_ sender: Any) {
        eventHandler?.login(emailText: emailTextField.text, passwordText: passwordTextField.text)
    }

    /**
     This method is the action receiver of the touch inside the sign up here button.
     
     - Parameter sender: Sender of the action, which is the sign up button
     */
    @IBAction func signUpHereButtonTapped(_ sender: Any) {
        eventHandler?.goToSignUp()
    }
    
    /**
     This method is responsible for resetting the view's input values, for the purpose of reusing.
     */
    public func prepareForReuse() {
        DispatchQueue.main.async {
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.emailErrorLabel.text = ""
            self.passwordErrorLabel.text = ""
        }
    }
    
    /**
     Sets the text of the email error label.
     
     - Parameter errorMessage: A string value that is displayed to the view.
     */
    internal func setEmailErrorLabel(errorMessage: String?) {
        DispatchQueue.main.async {
            self.emailErrorLabel.text = errorMessage
        }
    }
    
    
    /**
     Sets the text of the password error label.
     
     - Parameter errorMessage: A string value that is displayed to the view.
     */
    internal func setPasswordErrorLabel(errorMessage: String?) {
        DispatchQueue.main.async {
            self.passwordErrorLabel.text = errorMessage
        }
    }

}
