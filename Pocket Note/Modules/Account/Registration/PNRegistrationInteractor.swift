//
//  PNRegistrationInteractor.swift
//  Memo
//
//  Created by Hanet on 6/7/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import PSOperations

/**
 This struct handles the business logic of the Registration module.
 */
struct PNRegistrationInteractor {
    /// This is the view that contains the `UILabel` receiver of errors.
    var baseView: PNRegistrationView
    /// This is the controller that pushes the notes feed.
    var nextViewController: PNShowNotesFeedProtocol
    /// This is the view controller that receives network-related errors.
    var presentationContext: UIViewController
    
    /**
     This is the initialization method.
     
     - Parameter baseView: The view that contains the `UILabel` receiver of errors
     - Parameter nextViewController: The controller that pushes the notes feed
     - Parameter presentationContext: The view controller that receives network-related errors
     */
    init(baseView: PNRegistrationView, nextViewController: PNShowNotesFeedProtocol, presentationContext: UIViewController) {
        self.baseView = baseView
        self.nextViewController = nextViewController
        self.presentationContext = presentationContext
    }
    
    /**
     This method creares the operation chain for the registration module. It initializes the a `PNNetworkAvailabilityOperation` and a `PNLoginUserOperation`.
     
     - Parameter username: The username to be registered
     - Parameter password: The password of the username to be registered
     */
    fileprivate func createRegistrationOperationsChain(username: String, password: String) -> [PSOperation] {

//        let networkAvailabilityOperation = PNNetworkAvailabilityInteractor.init()
//        let registerOperation = PNLoginUserOperation.init(username: username, password: password, isRegister: true, nextViewController: nextViewController)
//        
//        let noNetworkObserver = PNNoNetworkObserver.init(presentationContext: presentationContext)
//        let existingUserAlreadErrorObserver = PNExistingUserErrorObserver.init(register: baseView)
//        
//        networkAvailabilityOperation.addObserver(noNetworkObserver)
//        registerOperation.addObserver(existingUserAlreadErrorObserver)
//        
//        registerOperation.addDependency(networkAvailabilityOperation)
//        return [networkAvailabilityOperation, registerOperation]
        return []
    }

}

extension PNRegistrationInteractor: PNRegistrationEventHandler {
    /**
     This is the event handler for Registration logic.
     
     - Parameter username: The username to be registered
     - Parameter password: The password of the username to be registered
     */
    func handleRegistration(username: String, password: String) {
        let loginOperationChain = createRegistrationOperationsChain(username: username, password: password)
        
        PNOperationQueue.networkOperationQueue.addOperations(loginOperationChain, waitUntilFinished: false)
    }
}
