//
//  PNLoginViewEventHandler.swift
//  Memo
//
//  Created by Hanet on 6/7/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

/**
 This class is a delegate of the actions performed on `PNLoginView`.
 */
protocol PNLoginViewVIPEREventHandler: class {
    func login(emailText: String?, passwordText: String?)
    func goToSignUp()
}

class PNLoginViewEventHandler: PNLoginViewVIPEREventHandler, VIPEREventHandler {
    /**
     This method is the protocol implementation of a delegate method that is called whenever the login button is tapped. This is responsible for checking the validity of the user input to the login form. If valid, this creates an instance to a chain of operations for login. Otherwise, this method outputs error messages to the respective views.
     */
    var loginView: PNLoginVIPERView
    var loginRouter: PNLoginVIPERRouter
    
    required init(loginView: PNLoginVIPERView, loginRouter: PNLoginVIPERRouter) {
        self.loginView = loginView
        self.loginRouter = loginRouter
    }
    
    final internal func login(emailText: String?, passwordText: String?) {
        // Login validation
        let loginInputValidationInteractor = PNLoginInputValidationInteractor.init(emailText: emailText, passwordText: passwordText)
        let loginInputValidationPresenter = PNLoginInputValidationPresenter.init(loginView: loginView)
        loginInputValidationInteractor.add(observer: loginInputValidationPresenter)
        
        // No Network
        let networkAvailabilityInteractor = PNNetworkAvailabilityInteractor.init()
        let noNetworkPresenter = PNNoNetworkPresenter.init(presentationContext: loginRouter)
        networkAvailabilityInteractor.add(observer: noNetworkPresenter)
        
        // Login to Realm
        let loginUserInteractor = PNLoginUserInteractor.init()
        let loginUserPresenter = PNLoginUserPresenter.init(loginView: loginView, loginRouter: loginRouter)
        loginInputValidationInteractor.add(observer: loginUserPresenter)
        loginUserInteractor.injectResult(from: loginInputValidationInteractor)
        
        PNOperationQueue.realmOperationQueue.add(operations: [networkAvailabilityInteractor, loginInputValidationInteractor, loginUserInteractor])
    }
    
    /**
     This method is a protocol implementation of the delegate method that is called whenever the user taps the sign up button.
     */
    final internal func goToSignUp() {
        self.loginRouter.routeToRegistration()
    }
}
