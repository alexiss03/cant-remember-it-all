//
//  PNInvalidLoginErrorObserver.swift
//  Memo
//
//  Created by Hanet on 5/30/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import PSOperations
import ProcedureKit

/**
 The`PNInvalidLoginErrorObserver` struct observes the errors returned by login operations.
 */

protocol PNLoginUserVIPERPresenter: VIPERPresenter { }

struct PNLoginUserPresenter: VIPERPresenter, ProcedureObserver {
    /// A `PNLoginViewProtocol` containing the emailErrorLabel where the error message can be displayed.
    private var loginView: PNLoginVIPERView
    private var loginRouter: PNLoginVIPERRouter
    
    /**
     Initializes the instance.
     
     - Parameter loginView: A `PNLoginViewProtocol` containing the emailErrorLabel where the error message can be displayed.
     */
    init(loginView: PNLoginVIPERView, loginRouter: PNLoginVIPERRouter) {
        self.loginView = loginView
        self.loginRouter = loginRouter
    }
    
    func did(cancel procedure: Procedure, withErrors: [Error]) {
        if let error = withErrors.first as NSError?, error.domain == "io.realm.sync", error.code ==  611 {
            loginView.setEmailErrorLabel(errorMessage: "Invalid login credentials.")
        }
    }
    
    func did(finish procedure: Procedure, withErrors: [Error]) {
        if withErrors.count == 0 {
            loginRouter.routeToNotesFeed()
        }
    }
}
