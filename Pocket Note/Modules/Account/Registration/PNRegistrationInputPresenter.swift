//
//  PNRegistrationInputPresenter.swift
//  Memo
//
//  Created by Hanet on 7/5/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import ProcedureKit

protocol PNRegistrationInputVIPERPresenter: VIPERPresenter { }

struct PNRegistrationInputPresenter: ProcedureObserver, PNRegistrationInputVIPERPresenter {
    var registrationView: PNRegistrationVIPERView
    
    init(registrationView: PNRegistrationVIPERView) {
        self.registrationView = registrationView
    }
    
    func did(cancel procedure: Procedure, withErrors: [Error]) {
        
        for error in withErrors {
            let error = error as NSError
            
            switch error.code {
            case _ where error.domain != PNRegistrationInputValidationErrorDomain:
                break
            case 0000:
                registrationView.setEmailErrorLabel(errorMessage: "You can't leave this empty")
            case 0001:
                registrationView.setEmailErrorLabel(errorMessage: "Invalid email format")
            case 0002:
                registrationView.setPasswordErrorLabel(errorMessage: "You can't leave this empty")
            case 0003:
                registrationView.setPasswordErrorLabel(errorMessage: "Password too short (minimum of 6 characters)")
            case 0004:
                registrationView.setPasswordErrorLabel(errorMessage: "Password too long (maximum of 30 characters)")
            default:
                break
            }
        }
    }
    
    func did(finish procedure: Procedure, withErrors errors: [Error]) {
        registrationView.setEmailErrorLabel(errorMessage: "")
        registrationView.setPasswordErrorLabel(errorMessage: "")
    }
}
