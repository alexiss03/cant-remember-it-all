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
import ProcedureKit

protocol VIPERView: class {
    
}

protocol VIPEREventHandler: class {
    
}

protocol VIPERPresenter: class {
    
}

protocol VIPERInteractor: class {
    
}

protocol VIPERInRouter: class {
    
}


class PNLoginViewEventHandler: PNLoginViewVIPEREventHandler, VIPEREventHandler {
    /**
     This method is the protocol implementation of a delegate method that is called whenever the login button is tapped. This is responsible for checking the validity of the user input to the login form. If valid, this creates an instance to a chain of operations for login. Otherwise, this method outputs error messages to the respective views.
     */
   //var loginValidationInteractor: PNLoginInputValidationInteractor
    var loginView: PNLoginVIPERView
    var presentationContext: UIViewController
    var loginRouter: PNLoginVIPERRouter
    
    required init(loginView: PNLoginVIPERView, presentationContext: UIViewController, loginRouter: PNLoginVIPERRouter) {
        self.loginView = loginView
        self.presentationContext = presentationContext
        self.loginRouter = loginRouter
        //self.loginValidationInteractor = loginValidationInteractor
    }
    
    internal func loginButtonTapped(emailText: String?, passwordText: String?) {
        let loginValidationInteractor = PNLoginInputValidationInteractor.init(emailText: emailText, passwordText: passwordText)
        let loginInputValidationPresenter = PNLoginInputValidationPresenter.init(loginView: loginView)
        loginValidationInteractor.add(observer: loginInputValidationPresenter)
        
        let networkAvailabilityInteractor = PNNetworkAvailabilityInteractor.init()
        let noNetworkPresenter = PNNoNetworkPresenter.init(presentationContext: presentationContext)
        networkAvailabilityInteractor.add(observer: noNetworkPresenter)
        
        let loginUserInteractor = PNLoginUserInteractor.init()
        let invalidLoginPresenter = PNInvalidLoginErrorPresenter.init(loginView: loginView)
        loginValidationInteractor.add(observer: invalidLoginPresenter)
        loginValidationInteractor.add(observer: loginRouter)
        loginUserInteractor.injectResult(from: loginValidationInteractor)
        
        
        PNOperationQueue.realmOperationQueue.add(operations: [networkAvailabilityInteractor, loginValidationInteractor, loginUserInteractor])
        //self.view.endEditing(true)
        
//        var isValidInput = true
//        
//        if emailText  == "" {
//            baseView?.emailErrorLabel.text = "You can't leave this empty"
//            isValidInput = false
//        } else if !validEmailFormat(string: baseView?.emailTextField.text) {
//            baseView?.emailErrorLabel.text = "Invalid email format"
//            isValidInput = false
//        } else {
//            baseView?.emailErrorLabel.text = ""
//        }
//        
//        if baseView?.passwordTextField.text == "" {
//            baseView?.passwordErrorLabel.text = "You can't leave this empty"
//            isValidInput = false
//        } else if let characters = baseView?.passwordTextField.text?.characters, characters.count < 6 {
//            baseView?.passwordErrorLabel.text = "Password too short (minimum of 6 characters)"
//            isValidInput = false
//        } else if let characters = baseView?.passwordTextField.text?.characters, characters.count > 30 {
//            baseView?.passwordErrorLabel.text = "Password too long (maximum of 30 characters)"
//            isValidInput = false
//        } else {
//            baseView?.passwordErrorLabel.text = ""
//        }
//        
//        if let username = baseView?.emailTextField.text, let password = baseView?.passwordTextField.text, isValidInput {
//            loginInteractor?.handleLogin(username: username, password: password)
//        }
    }
    
    /**
     This method is a protocol implementation of the delegate method that is called whenever the user taps the sign up button.
     */
    final internal func signUpHereButtonTapped() {
        //showRegistration()
    }
}

public let PNLoginInputValidationErrorDomain: String = "error.login.input.validation"

final class PNLoginInputValidationInteractor: Procedure, OutputProcedure, VIPERInteractor {
    
    /**
     This method that returns a boolean value for checking a string valid email format.
     
     - Paramter string: String to be validated for email format
     */
    struct EmailValidator {
        static func validEmailFormat(string: String?) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let result = emailTest.evaluate(with: string)
            return result
        }
    }
    
    //private var loginPresenter: PNLoginInputValidationPresenter
    //private var loginToRealmInteractor: PNLoginInteractor
    private var username: String?
    private var password: String?
    
    private var isValidInput = true
    internal var output: Pending<ProcedureResult<(String, String)>> = .pending
    
    required init(emailText username: String?, passwordText password: String?) {
        self.username = username
        self.password = password
        super.init()
        //self.loginPresenter = loginPresenter
        //self.loginToRealmInteractor = loginToRealmInteractor
    }
    
    override func execute() {
        if username  == "" {
            let emptyEmailError = NSError.init(domain: PNLoginInputValidationErrorDomain, code: 0000, userInfo: nil)
            //loginPresenter.userInputError(error: emptyEmailError)
            cancel(withError: emptyEmailError)
            //baseView?.emailErrorLabel.text = "You can't leave this empty"
            isValidInput = false
        } else if !EmailValidator.validEmailFormat(string: username) {
            let invalidFormatError = NSError.init(domain: PNLoginInputValidationErrorDomain, code: 0001, userInfo: nil)
            cancel(withError: invalidFormatError)
            //loginPresenter.userInputError(error: invalidFormatError)
            //baseView?.emailErrorLabel.text = "Invalid email format"
            isValidInput = false
        } else {
            //finish()
            //let resetEmailTextError = NSError.init(domain: PNLoginInputValidationErrorDomain, code: 0002, userInfo: nil)
            //finish(withError: resetEmailTextError)
            //loginPresenter.userInputError(error: error)
            //baseView?.emailErrorLabel.text = ""
        }
        
        if password == "" {
            let emptyPasswordError = NSError.init(domain: PNLoginInputValidationErrorDomain, code: 0003, userInfo: nil)
            cancel(withError: emptyPasswordError)
            //loginPresenter.userInputError(error: error)
            //baseView?.passwordErrorLabel.text = "You can't leave this empty"
            isValidInput = false
        } else if let characters = password?.characters, characters.count < 6 {
            let passwordTooShortError = NSError.init(domain: PNLoginInputValidationErrorDomain, code: 0004, userInfo: nil)
            cancel(withError: passwordTooShortError)
            //loginPresenter.userInputError(error: error)
            //baseView?.passwordErrorLabel.text = "Password too short (minimum of 6 characters)"
            isValidInput = false
        } else if let characters = password?.characters, characters.count > 30 {
            let passwordTooLongError = NSError.init(domain: PNLoginInputValidationErrorDomain, code: 0005, userInfo: nil)
            cancel(withError: passwordTooLongError as Error)
            //loginPresenter.userInputError(error: error)
            //baseView?.passwordErrorLabel.text = "Password too long (maximum of 30 characters)"
            isValidInput = false
        } else {
            //let resetPasswordTextError = NSError.init(domain: PNLoginInputValidationErrorDomain, code: 0006, userInfo: nil)
            //finish()
            //finish(withError: resetPasswordTextError)
            //loginPresenter.userInputError(error: error)
            //baseView?.passwordErrorLabel.text = ""
        }
        
        guard let unwrappedUsername = username, let unwrappedPassword = password, isValidInput else {
            print("Login input credentials is invalid")
            return
        }
        
        self.finish(withResult: .success((unwrappedUsername, unwrappedPassword)))
//
        //self.loginToRealmInteractor.handleLogin(username: unwrappedUsername, password: unwrappedPassword)
    }
}

class PNLoginInputValidationPresenter: ProcedureObserver, VIPERPresenter {
    var loginView: PNLoginVIPERView
    
    required init(loginView: PNLoginVIPERView) {
        self.loginView = loginView
    }
    
    internal func did(cancel procedure: Procedure, withErrors: [Error]) {
        for error in withErrors {
            let error = error as NSError
            
            switch error.code {
                case _ where error.domain != PNLoginInputValidationErrorDomain:
                    break
                case 0000:
                    loginView.setEmailErrorLabel(errorMessage: "You can't leave this empty")
                case 0001:
                    loginView.setEmailErrorLabel(errorMessage: "Invalid email format")
                case 002:
                    loginView.setEmailErrorLabel(errorMessage: "")
                case 003:
                    loginView.setEmailErrorLabel(errorMessage: "You can't leave this empty")
                case 004:
                    loginView.setPasswordEmailErrorLabel(errorMessage: "Password too short (minimum of 6 characters)")
                case 005:
                    loginView.setPasswordEmailErrorLabel(errorMessage: "Password too long (maximum of 30 characters)")
                case 006:
                    loginView.setPasswordEmailErrorLabel(errorMessage: "")
                default:
                    break
            }
        }
    }
  
    internal func did(finish procedure: Procedure, withErrors errors: [Error]) {
        loginView.setEmailErrorLabel(errorMessage: "")
        loginView.setPasswordEmailErrorLabel(errorMessage: "")
    }
}

class PNLoginVIPERRouter: ProcedureObserver, VIPERInRouter {
    var sourceViewController: UIViewController
    var mainNavigationController: UINavigationController
    var sideMenuViewController: PNSideMenuViewController
    
    required init(sourceViewController: UIViewController, mainNavigationController: UINavigationController, sideMenuViewController: PNSideMenuViewController) {
        self.sourceViewController = sourceViewController
        self.mainNavigationController = mainNavigationController
        self.sideMenuViewController = sideMenuViewController
    }
    
    internal func did(finish procedure: Procedure, withErrors: [Error]) {
        if withErrors.count == 0 {
            let slideMenuController = SlideMenuController(mainViewController:mainNavigationController, leftMenuViewController: sideMenuViewController)
            SlideMenuOptions.contentViewScale = 1
            SlideMenuOptions.hideStatusBar = false
            SlideMenuOptions.contentViewDrag = true
            
            DispatchQueue.main.async {
                self.sourceViewController.present(slideMenuController, animated: true, completion: nil)
                self.sourceViewController.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

/**
 This class is the view controller for the Login module.
 */
class PNLoginViewController: UIViewController, PNNavigationBarProtocol {
    var eventHandler: PNLoginViewEventHandler?
    //var loginInputValidationInteractor: PNLoginValidationInteractor?
    
    /// This instance property is the superview of the current controller.
    let baseView: PNLoginView? = {
        if let view = Bundle.main.loadNibNamed("PNLoginView", owner: self, options: nil)![0] as? PNLoginView {
            return view
        }
        return nil
    }()
    
    /// This instance property holds the login interactor that serves as an event handler.
    //fileprivate var loginInteractor: PNLoginViewEventHandler?

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
            
            //let eventHandler: PNLoginViewEventHandler.init()
            
            //unwrappedBaseView.eventHandler = eventHandler
            initializeInteractors()
            assembleInteractors()
        }
    }
    
    /**
     This method is responsible for initializing interactors such as the `PNLoginInteractor`.
     */
    private func initializeInteractors() {
//        if let unwrappedBaseView = baseView {
//            loginInteractor = PNLoginInteractor.init(baseView: unwrappedBaseView, nextViewController: self, presentationContext: self)
//        }
    }
    
    private func assembleInteractors() {
        
        if let unwrappedBaseView = baseView {
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            guard let unwrappedMainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationController") as? UINavigationController else {
                print("Notes Feed View Controller is nil")
                return
            }
            
            guard let unwrappedSideMenuViewController = mainStoryboard.instantiateViewController(withIdentifier: "PNSideMenuViewController") as? PNSideMenuViewController else {
                print("Side Menu View Controller is nil")
                return
            }
            
            let loginRouter = PNLoginVIPERRouter.init(sourceViewController: self, mainNavigationController: unwrappedMainViewController, sideMenuViewController: unwrappedSideMenuViewController)
            let loginEventHandler = PNLoginViewEventHandler.init(loginView: unwrappedBaseView, presentationContext: self, loginRouter: loginRouter)
            baseView?.eventHandler = loginEventHandler
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
     This method calls a perform segue to the Registration page.
     */
    final fileprivate func showRegistration() {
        self.performSegue(withIdentifier: "TO_REGISTRATION", sender: self)
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
