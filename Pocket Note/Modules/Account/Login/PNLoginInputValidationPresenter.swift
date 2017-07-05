//
//  PNLoginInputValidationPresenter.swift
//  Memo
//
//  Created by Hanet on 7/5/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import ProcedureKit

protocol PNLoginInputValidationVIPERPresenter { }

struct PNLoginInputValidationPresenter: ProcedureObserver, PNLoginInputValidationVIPERPresenter, VIPERPresenter {
    var loginView: PNLoginVIPERView
    
    init(loginView: PNLoginVIPERView) {
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
            case 0002:
                loginView.setPasswordErrorLabel(errorMessage: "You can't leave this empty")
            case 0003:
                loginView.setPasswordErrorLabel(errorMessage: "Password too short (minimum of 6 characters)")
            case 0004:
                loginView.setPasswordErrorLabel(errorMessage: "Password too long (maximum of 30 characters)")
            default:
                break
            }
        }
    }
    
    internal func did(finish procedure: Procedure, withErrors errors: [Error]) {
        loginView.setEmailErrorLabel(errorMessage: "")
        loginView.setPasswordErrorLabel(errorMessage: "")
    }
}
