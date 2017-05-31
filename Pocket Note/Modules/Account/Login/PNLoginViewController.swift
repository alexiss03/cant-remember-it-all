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

class PNLoginViewController: UIViewController, PNNavigationBarProtocol, PNLoginViewDelegate {
    let baseView: PNLoginView? = {
        if let view = Bundle.main.loadNibNamed("PNLoginView", owner: self, options: nil)![0] as? PNLoginView {
            return view
        }
        return nil
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedBaseView = self.baseView {
            unwrappedBaseView.frame = self.view.frame
            self.view = unwrappedBaseView
            
            unwrappedBaseView.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar(viewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func validEmailFormat(string: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: string)
        return result
    }
    
    private func showRegistration() {
        self.performSegue(withIdentifier: "TO_REGISTRATION", sender: self)
    }
    
    // MARK: PNLoginViewDelegate Methods
    func loginButtonTapped() {
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
            let loginOperationChain = createLoginOperationChain(username: username, password: password)
            
            RealmConstants.networkOperationQueue.addOperations(loginOperationChain, waitUntilFinished: false)
        }
    }
    
    func signUpHereButtonTapped() {
        showRegistration()
    }
    
}

extension PNLoginViewController: PNShowNotesFeedProtocol {
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
    }
}

extension PNLoginViewController {
    func createLoginOperationChain(username: String, password: String) -> [PSOperation] {
        guard let unwrappedBaseView = baseView else {
            print("Login base view is nil")
            return []
        }
        
        let loginOperation = PNLoginUserOperation.init(username: username, password: password, nextViewController: self)
        let networkAvailabilityOperation = PNNetworkAvailabilityOperation.init()
        
        let noNetworkObserver = PNNoNetworkObserver.init(presentationContext: self)
        let invalidLoginObserver = PNInvalidLoginCredentialsErrorObserver.init(loginView: unwrappedBaseView)
        
        networkAvailabilityOperation.addObserver(noNetworkObserver)
        loginOperation.addObserver(invalidLoginObserver)
        
        loginOperation.addDependency(networkAvailabilityOperation)
        return [networkAvailabilityOperation, loginOperation]
    }
}
