//
//  PNLoginInputPresenter.swift
//  Memo
//
//  Created by Hanet on 7/5/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import ProcedureKit

/**
 The `PNLoginInputValidationVIPERPresenter` representing the VIPER PRESENTER for  `PNLoginInputInteractor` VIPER INTERACTOR.
 */
protocol PNLoginInputValidationVIPERPresenter { }

/**
 The `PNLoginInputPresenter` struct conforms to LOGIN INPUT VIPER PRESENTER.
 */
struct PNLoginInputPresenter: ProcedureObserver, PNLoginInputValidationVIPERPresenter, VIPERPresenter {
    var loginView: PNLoginVIPERView
    
    /**
     Initializes the instance.
     
     - Parameter loginView: A `PNLoginVIPERView` conforming objet for the VIPER VIEW
     */
    init(loginView: PNLoginVIPERView) {
        self.loginView = loginView
    }
    
    /**
     Displays the errors in LOGIN VIPER VIEW.
     */
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
    
    /**
     Resets the LOGIN VIPER VIEW if there is no input error.
     */
    internal func did(finish procedure: Procedure, withErrors errors: [Error]) {
        loginView.setEmailErrorLabel(errorMessage: "")
        loginView.setPasswordErrorLabel(errorMessage: "")
    }
}
