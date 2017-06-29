//
//  PNRegistrationViewController.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

import SlideMenuControllerSwift
import RealmSwift
import PSOperations

/**
    The view controller class responsible for the Registration module.
 */
class PNRegistrationViewController: UIViewController, PNNavigationBarProtocol, PNRegistrationViewDelegate {
    
    /// This is the main view of the registration page.
    let baseView: PNRegistrationView? = {
        if let view = Bundle.main.loadNibNamed("PNRegistrationView", owner: self, options: nil)![0] as? PNRegistrationView {
            return view
        }
        return nil
    }()
    
    /// This is the event handler for the Registration module.
    var registrationEventHandler: PNRegistrationEventHandler?

    /**
     This method overrides `viewDidLoad()` to initialize the `baseView` and set the navigation bar visibility.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        if let unwrappedBaseView = self.baseView {
            unwrappedBaseView.frame = self.view.frame
            self.view = unwrappedBaseView

            unwrappedBaseView.delegate = self
        }

        showNavigationBar(viewController: self)
        initializeInteractors()
    }

    /**
     This methods initializes logic interactors for this class
     */
    private func initializeInteractors() {
        if let unwrappedBaseView = baseView {
            registrationEventHandler = PNRegistrationInteractor.init(baseView: unwrappedBaseView, nextViewController: self, presentationContext: self)
        }
    }
    
    // MARK: PNRegistrationViewDelegate Methods
    /**
        This method acts when the sign up button is tapped. This checks the validity of the user input in the forms. If valid, performs the chain of operation for the login operations. If invalid, shows the necessary error messages.
     
     */
    func signUpButtonTapped() {
        self.view.endEditing(true)
        
        var isValidInput = true
        
        if baseView?.emailTextField.text == "" {
            baseView?.emailErrorLabel.text = "You can't leave this empty"
            isValidInput = false
        } else if !validEmailFormat(string: baseView?.emailTextField.text) {
            baseView?.emailErrorLabel.text = "Invalid email format"
            isValidInput = false
        } else {
            baseView?.emailErrorLabel.text = ""
        }
        
        if baseView?.passwordTextField.text == "" {
            baseView?.passwordErrorLabel.text = "You can't leave this empty"
            isValidInput = false
        } else if let characters = baseView?.passwordTextField.text?.characters, characters.count < 6 {
            baseView?.passwordErrorLabel.text = "Password too short (minimum of 6 characters)"
            isValidInput = false
        } else if let characters = baseView?.passwordTextField.text?.characters, characters.count > 30 {
            baseView?.passwordErrorLabel.text = "Password too long (maximum of 30 characters)"
            isValidInput = false
        } else {
            baseView?.passwordErrorLabel.text = ""
        }
        
        if let username = baseView?.emailTextField.text, let password = baseView?.passwordTextField.text, isValidInput {
            registrationEventHandler?.handleRegistration(username: username, password: password)
        }
    }

    /**
        This method checks if an input string is in the form of a valid email address.
     
        - Parameter string: Input string to be checked for email format.
     */
    func validEmailFormat(string: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: string)
        return result
    }
}

extension PNRegistrationViewController: PNShowNotesFeedProtocol {
    /**
     This is an implementation method of a protocol method for `PNShowNotesFeedProtocol`. This directs the current view controller to the notes feed screen.
     */
    func showNotesFeed() {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let unwrappedMainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationController") as? UINavigationController else {
            print("Notes Feed View Controller is nil")
            return
        }

        guard let unwrappedSideMenuViewController = mainStoryboard.instantiateViewController(withIdentifier: "PNSideMenuViewController") as? PNSideMenuViewController else {
            print("Side Menu View Controller is nil")
            return
        }

        let slideMenuController = SlideMenuController(mainViewController:unwrappedMainViewController, leftMenuViewController: unwrappedSideMenuViewController)
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.hideStatusBar = false
        SlideMenuOptions.contentViewDrag = true

        present(slideMenuController, animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
}
