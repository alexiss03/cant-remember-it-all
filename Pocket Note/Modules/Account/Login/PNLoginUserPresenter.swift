//
//  PNInvalidLoginErrorObserver.swift
//  Memo
//
//  Created by Hanet on 5/30/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import ProcedureKit
import RealmSwift

/**
 The `PNLoginUserVIPERPresenter` representing the VIPER PRESENTER for the `PNLoginUserInteractor` VIPER INTERACTOR.
 */
protocol PNLoginUserVIPERPresenter: VIPERPresenter { }

/**
 The `PNLoginUserPresenter` struct conform to the LOGIN VIPER PRESENTER.
 */
struct PNLoginUserPresenter: VIPERPresenter, ProcedureObserver {
    /// A `PNLoginVIPERView` conforming object for the VIPER VIEW.
    private var loginView: PNLoginVIPERView
    /// A `PNLoginVIPERRouter` confroming object for the VIPER ROUTER.
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
    }
}

struct PNLoginMigrateDataPresenter: VIPERPresenter, ProcedureObserver {
    /// A `PNLoginVIPERRouter` confroming object for the VIPER ROUTER.
    private var loginRouter: PNLoginVIPERRouter
    
    /**
     Initializes the instance.
     
     - Parameter loginView: A `PNLoginViewProtocol` containing the emailErrorLabel where the error message can be displayed.
     */
    init(loginRouter: PNLoginVIPERRouter) {
        self.loginRouter = loginRouter
    }
    
    func did(cancel procedure: Procedure, withErrors: [Error]) { }
    
    func did(finish procedure: Procedure, withErrors: [Error]) {
        if withErrors.count == 0 {
            loginRouter.routeToNotesFeed()
        }
    }
    
}
