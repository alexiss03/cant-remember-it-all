//
//  PNRegistrationInputValidationInteractor.swift
//  Memo
//
//  Created by Hanet on 7/5/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import ProcedureKit

public let PNRegistrationInputValidationErrorDomain: String = "error.registration.input.validation"

protocol PNRegistrationInputValidationVIPERInteractor: class { }

final class PNRegistrationInputValidationInteractor: Procedure, OutputProcedure, PNRegistrationInputValidationVIPERInteractor, VIPERInteractor {
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
    
    private var username: String?
    private var password: String?
    
    private var isValidInput = true
    internal var output: Pending<ProcedureResult<(String, String)>> = .pending
    
    required init(emailText username: String?, passwordText password: String?) {
        self.username = username
        self.password = password
        super.init()
    }
    
    internal override func execute() {
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
            print("Registration input credentials is invalid")
            return
        }
        
        finish(withResult: .success((unwrappedUsername, unwrappedPassword)))
    }
    
    private func validaUserName() -> Error? {
        if username  == "" {
            let emptyEmailError = NSError.init(domain: PNRegistrationInputValidationErrorDomain, code: 0000, userInfo: nil)
            return emptyEmailError
        } else if !EmailValidator.validEmailFormat(string: username) {
            let invalidFormatError = NSError.init(domain: PNRegistrationInputValidationErrorDomain, code: 0001, userInfo: nil)
            return invalidFormatError
        }
        return nil
    }
    
    private func validatePassword() -> Error? {
        if password == "" {
            let emptyPasswordError = NSError.init(domain: PNRegistrationInputValidationErrorDomain, code: 0002, userInfo: nil)
            return emptyPasswordError
        } else if let characters = password?.characters, characters.count < 6 {
            let passwordTooShortError = NSError.init(domain: PNRegistrationInputValidationErrorDomain, code: 0003, userInfo: nil)
            return passwordTooShortError
        } else if let characters = password?.characters, characters.count > 30 {
            let passwordTooLongError = NSError.init(domain: PNRegistrationInputValidationErrorDomain, code: 0004, userInfo: nil)
            return passwordTooLongError
        }
        
        return nil
    }
}
