//
//  PNLoginInputInteractor.swift
//  Memo
//
//  Created by Hanet on 7/5/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import ProcedureKit

/// The `PNLoginInputValidationErrorDomain` is the error domain for the input login from the user.
public let PNLoginInputValidationErrorDomain: String = "error.login.input.validation"

/// The `PNLoginInputVIPERInteractor` represents the VIPER INTERACTOR.
protocol PNLoginInputVIPERInteractor: VIPERInteractor { }

/**
 The `PNLoginInputInteractor` conforms to login VIPER INTERACTOR
 */
final class PNLoginInputInteractor: Procedure, OutputProcedure, PNLoginInputVIPERInteractor, VIPERInteractor {
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
    
    /// An optional string value representing the username from the event handler.
    private var username: String?
    /// A optional string value representing the password from the event handler.
    private var password: String?
    
    /// A tuple (String, String) value that is the output of this interactor.
    var output: Pending<ProcedureResult<(String, String)>> = .pending
    
    required init(emailText username: String?, passwordText password: String?) {
        self.username = username
        self.password = password
        super.init()
    }
    
    override func execute() {
        var errors: [Error] = []
        
        if let usernameError = validaUserName() {
            errors.append(usernameError)
        }
        
        if let passwordError = validatePassword() {
            errors.append(passwordError)
        }
        
        guard errors.count == 0 else {
            cancel(withErrors: errors)
            return
        }
        
        guard let unwrappedUsername = username, let unwrappedPassword = password else {
            print("Login input credentials is invalid")
            return
        }
        
        finish(withResult: .success((unwrappedUsername, unwrappedPassword)))
    }
    
    /**
     Validates the username format.
     
     - Returns: An error value if the username is invalid. If valid, returns nil.
     */
    private func validaUserName() -> Error? {
        if username  == "" {
            let emptyEmailError = NSError.init(domain: PNLoginInputValidationErrorDomain, code: 0000, userInfo: nil)
            return emptyEmailError
        } else if !EmailValidator.validEmailFormat(string: username) {
            let invalidFormatError = NSError.init(domain: PNLoginInputValidationErrorDomain, code: 0001, userInfo: nil)
            return invalidFormatError
        }
        return nil
    }
    
    /**
     Validates the password format.
     
     - Returns: An error value if the password is invalid. If invalid, returns nil.
     */
    private func validatePassword() -> Error? {
        if password == "" {
            let emptyPasswordError = NSError.init(domain: PNLoginInputValidationErrorDomain, code: 0002, userInfo: nil)
            return emptyPasswordError
        } else if let characters = password?.characters, characters.count < 6 {
            let passwordTooShortError = NSError.init(domain: PNLoginInputValidationErrorDomain, code: 0003, userInfo: nil)
            return passwordTooShortError
        } else if let characters = password?.characters, characters.count > 30 {
            let passwordTooLongError = NSError.init(domain: PNLoginInputValidationErrorDomain, code: 0004, userInfo: nil)
            return passwordTooLongError
        }
        
        return nil
    }
}
