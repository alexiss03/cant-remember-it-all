//
//  PNLoginViewController.swift
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
 This class is the view controller for the Login module.
 */
class PNLoginViewController: UIViewController, PNNavigationBarProtocol {
    
    /// This instance property is the superview of the current controller.
    let baseView: PNLoginView? = {
        if let view = Bundle.main.loadNibNamed("PNLoginView", owner: self, options: nil)![0] as? PNLoginView {
            return view
        }
        return nil
    }()
    
    /// This instance property holds the login interactor that serves as an event handler.
    fileprivate var loginInteractor: PNLoginViewEventHandler?

    /** 
     This method overrides the superclass' implementation of `viewDidLoad()` to set the `baseView` and setting the baseView delegate.
    */
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        if !SyncUser.all.isEmpty {
            showNotesFeed()
        }
        
        if let unwrappedBaseView = self.baseView {
            unwrappedBaseView.frame = self.view.frame
            self.view = unwrappedBaseView
            
            unwrappedBaseView.delegate = self
            initializeInteractors()
        }
    }
    
    /**
     This method is responsible for initializing interactors such as the `PNLoginInteractor`.
     */
    private func initializeInteractors() {
        if let unwrappedBaseView = baseView {
            loginInteractor = PNLoginInteractor.init(baseView: unwrappedBaseView, nextViewController: self, presentationContext: self)
        }
    }
    
    /** 
     This method overrides the superclass' implementation of `viewWillAppear()` set the navigation bar's visibility and resetting the `baseView` to reusing
    */
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar(viewController: self)
        baseView?.prepareForReuse()
    }
    
    /**
     This method that returns a boolean value for checking a string valid email format.
     
     - Paramter string: String to be validated for email format
    */
    final fileprivate func validEmailFormat(string: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: string)
        return result
    }
    
    /**
     This method calls a perform segue to the Registration page.
     */
    final fileprivate func showRegistration() {
        self.performSegue(withIdentifier: "TO_REGISTRATION", sender: self)
    }
}

extension PNLoginViewController: PNLoginViewDelegate {
    /**
     This method is the protocol implementation of a delegate method that is called whenever the login button is tapped. This is responsible for checking the validity of the user input to the login form. If valid, this creates an instance to a chain of operations for login. Otherwise, this method outputs error messages to the respective views.
     */
    final internal func loginButtonTapped() {
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
            loginInteractor?.handleLogin(username: username, password: password)
        }
    }
    
    /**
     This method is a protocol implementation of the delegate method that is called whenever the user taps the sign up button.
     */
    final internal func signUpHereButtonTapped() {
        showRegistration()
    }
    
}

extension PNLoginViewController: PNShowNotesFeedProtocol {
    /**
     This method directs this view controller to the event's feed page.
     */
    final internal func showNotesFeed() {
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
    }
}
