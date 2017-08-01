//
//  PNLoginViewEventHandler.swift
//  Memo
//
//  Created by Hanet on 6/7/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

/**
 The `PNLoginVIPEREventHandler` protocol subclasses the VIPEREventHandler. 
 
 An object conforming to this protocol handles the event from the view.
 */
protocol PNLoginVIPEREventHandler: VIPEREventHandler {
    func login(emailText: String?, passwordText: String?)
    func goToSignUp()
    func dimiss()
}

class PNLoginViewEventHandler: PNLoginVIPEREventHandler {
    /// A `PNLoginVIPERView` conforming object that represents the VIPER VIEW for Login module.
    var loginView: PNLoginVIPERView
    /// A `PNLoginVIPERRouter` conforming object that represents the VIPER ROUTER for Login module.
    var loginRouter: PNLoginVIPERRouter
    var presentationContext: UIViewController
    
    /**
     Initializes the instance.
     
     - Parameter loginView: A `PNLoginVIPERView` conforming object that represents the VIPER VIEW for Login module.
     - Parameter loginRouter: A `PNLoginVIPERRouter` conforming object that represents the VIPER ROUTER for Login module.
    */
    init(loginView: PNLoginVIPERView, loginRouter: PNLoginVIPERRouter, presentationContext: UIViewController) {
        self.loginView = loginView
        self.loginRouter = loginRouter
        self.presentationContext = presentationContext
    }
    
    /**
     Handles event when the user taps the login button.
     
     - Parameter emailText: An optional string value for the text input in the email text field by the user.
     - Parameter passwordText: An optionla string value for the text input in the password text field by the user.
     */
    func login(emailText: String?, passwordText: String?) {
        // Login validation
        let loginInputValidationInteractor = PNLoginInputInteractor.init(emailText: emailText, passwordText: passwordText)
        let loginInputValidationPresenter = PNLoginInputPresenter.init(loginView: loginView)
        loginInputValidationInteractor.add(observer: loginInputValidationPresenter)
        
        // No Network
        let networkAvailabilityInteractor = PNNetworkAvailabilityInteractor.init()
        let noNetworkPresenter = PNNoNetworkPresenter.init(presentationContext: loginRouter)
        networkAvailabilityInteractor.add(observer: noNetworkPresenter)
        
        // Login to Realm
        let loginUserInteractor = PNLoginUserInteractor.init()
        let loginUserPresenter = PNLoginUserPresenter.init(loginView: loginView, loginRouter: loginRouter)
        
        // Migrate local data to Realm
        let loginMigrateDataInteractor = PNLoginMigrateDataInteractor.init(presentationContext: presentationContext)
        let loginMigrateDataPressenter = PNLoginMigrateDataPresenter.init(loginRouter: loginRouter)
        
        loginUserInteractor.add(observer: loginUserPresenter)
        loginMigrateDataInteractor.add(observer: loginMigrateDataPressenter)
        loginUserInteractor.injectResult(from: loginInputValidationInteractor)
        loginMigrateDataInteractor.injectResult(from: loginUserInteractor)
        
        PNOperationQueue.realmOperationQueue.add(operations: [networkAvailabilityInteractor, loginInputValidationInteractor, loginUserInteractor, loginMigrateDataInteractor])
    }
    
    /**
     This method is a protocol implementation of the delegate method that is called whenever the user taps the sign up button.
     */
    func goToSignUp() {
        self.loginRouter.routeToRegistration()
    }
    
    func dimiss() {
        self.loginRouter.dismiss()
    }
}
