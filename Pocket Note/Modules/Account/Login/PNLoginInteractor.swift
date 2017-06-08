//
//  PNLoginInteractor.swift
//  Memo
//
//  Created by Hanet on 6/7/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import PSOperations

/**
 This struct contains the business logic of the Login module.
 */
struct PNLoginInteractor {
    /// This is the view that contains the `UILabel` that receives errors.
    var baseView: PNLoginView
    /// This is the view controller that redirects the login page to the notes feed page.
    var nextViewController: PNShowNotesFeedProtocol
    /// This is the view controller that presents network-related errors.
    var presentationContext: UIViewController
    
    /**
     This is the initialization method.
     
     - Parameter baseView: This is the view that contains the `UILabel` that receives errors.
     - Parameter nextViewController: This is the view controller that redirects the login page to the notes feed page.
     - Parameter presentationContext: This is the view controller that presents network-related errors.
     */
    init(baseView: PNLoginView, nextViewController: PNShowNotesFeedProtocol, presentationContext: UIViewController) {
        self.baseView = baseView
        self.nextViewController = nextViewController
        self.presentationContext = presentationContext
    }
    
    /**
     This method creates login operation chain responsible for the business logic of the Login module. It creates a chain of `PNNetworkAvailabilityOperation` and `PNInvalidLoginErrorObserver`.
     
     - Parameter username: The username of the account to be logged in.
     - Parameter password: The password of the account to be logged in.
     */
     fileprivate func createLoginOperationChain(username: String, password: String) -> [PSOperation] {

        let networkAvailabilityOperation = PNNetworkAvailabilityOperation.init()
        let loginOperation = PNLoginUserOperation.init(username: username, password: password, nextViewController: nextViewController)
        
        let noNetworkObserver = PNNoNetworkObserver.init(presentationContext: presentationContext)
        let invalidLoginObserver = PNInvalidLoginErrorObserver.init(loginView: baseView)
        
        networkAvailabilityOperation.addObserver(noNetworkObserver)
        loginOperation.addObserver(invalidLoginObserver)
        
        loginOperation.addDependency(networkAvailabilityOperation)
        return [networkAvailabilityOperation, loginOperation]
    }
}

extension PNLoginInteractor: PNLoginViewEventHandler {
    /**
     This method handles the actual login business logic. It queues the chain of operation returned by `createLoginOperationChain`.
     
     - Parameter username: The username of the account to be logged in.
     - Parameter password: The password of the account to be logged in.
     */
    public func handleLogin(username: String, password: String) {
        let loginOperationChain = createLoginOperationChain(username: username, password: password)
        
        PNOperationQueue.networkOperationQueue.addOperations(loginOperationChain, waitUntilFinished: false)
    }
}
