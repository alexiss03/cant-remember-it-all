//
//
//  PNRegistrationEventHandler.swift
//  Memo
//
//  Created by Hanet on 6/7/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//c

/**
 The `PNRegistrationEventHandler` protocol contains event handler's for the Registratiosn module.
 */
protocol PNRegistrationVIPEREventHandler {
    func signUp(emailText: String?, passwordText: String?)
}

class PNRegistrationEventHandler: PNRegistrationVIPEREventHandler {
    var registrationView: PNRegistrationVIPERView
    var registrationRouter: PNRegistrationVIPERRouter
    
    required init(registrationView: PNRegistrationVIPERView, registrationRouter: PNRegistrationVIPERRouter) {
        self.registrationView = registrationView
        self.registrationRouter = registrationRouter
    }
    
    func signUp(emailText: String?, passwordText: String?) {
        // User Input Validation
        let registrationInputValidationInteractor = PNRegistrationInputInteractor.init(emailText: emailText, passwordText: passwordText)
        let registrationInputValidationPresenter = PNRegistrationInputPresenter.init(registrationView: registrationView)
        registrationInputValidationInteractor.add(observer: registrationInputValidationPresenter)

        // No Network
        let networkAvailabilityInteractor = PNNetworkAvailabilityInteractor.init()
        let noNetworkPresenter = PNNoNetworkPresenter.init(presentationContext: registrationRouter)
        networkAvailabilityInteractor.add(observer: noNetworkPresenter)

        // Login to Realm
        let registrationUserInteractor = PNRegistrationUserInteractor.init()
        let registrationUserPresenter = PNRegistrationUserPresenter.init(registrationView: registrationView, registrationRouter: registrationRouter)
        registrationUserInteractor.add(observer: registrationUserPresenter)
        registrationUserInteractor.injectResult(from: registrationInputValidationInteractor)

        PNOperationQueue.realmOperationQueue.add(operations: [registrationInputValidationInteractor, networkAvailabilityInteractor, registrationUserInteractor])
    }
}
