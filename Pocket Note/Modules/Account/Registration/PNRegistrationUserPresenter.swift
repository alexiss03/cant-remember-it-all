//
//  PNRegistrationUserPresenter.swift
//  Memo
//
//  Created by Hanet on 7/5/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import ProcedureKit

protocol PNRegistrationUserVIPERPresenter: VIPERPresenter { }

struct PNRegistrationUserPresenter: VIPERPresenter, ProcedureObserver {
    private var registrationView: PNRegistrationVIPERView
    private var registrationRouter: PNRegistrationVIPERRouter
    
    /**
     Initializes the instance.
     
     */
    init(registrationView: PNRegistrationVIPERView, registrationRouter: PNRegistrationVIPERRouter) {
        self.registrationView = registrationView
        self.registrationRouter = registrationRouter
    }
    
    func did(cancel procedure: Procedure, withErrors: [Error]) {
        if let error = withErrors.first as NSError?, error.domain == "io.realm.sync.auth", error.code ==  611 {
            registrationView.setEmailErrorLabel(errorMessage: "Invalid registration credentials.")
        }
    }
    
    func did(finish procedure: Procedure, withErrors: [Error]) {
        if withErrors.count == 0 {
            registrationRouter.routeToNotesFeed()
        }
    }
}
