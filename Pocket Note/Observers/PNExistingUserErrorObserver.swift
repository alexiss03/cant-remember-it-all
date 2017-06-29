//
//  PNExistingUserErrorObserver.swift
//  Memo
//
//  Created by Hanet on 5/30/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import PSOperations

/**
 The `PNExistingUserErrorObserver` struct observes if the registration fails.
 */
struct PNExistingUserErrorObserver: OperationObserver {
    /// A `PNRegistrationViewProtocol` instance containing the emailErrorLabel where an error can be possible displayed.
    weak var register: PNRegistrationViewProtocol?
    
    /**
     Initializes the instance.
     
     - Parameter register: A `PNRegistrationViewProtocol` instance containing the emailErrorLabel where an error can be possible displayed.
     */
    init(register: PNRegistrationViewProtocol) {
        self.register = register
    }
    
    func operationDidStart(_ operation: PSOperation) {
    }
    
    func operationDidCancel(_ operation: PSOperation) {
        
    }
    
    func operation(_ operation: PSOperation, didProduceOperation newOperation: Foundation.Operation) {
        
    }
    
    /**
     Observes and displays the user already existing error.
     
     - Parameter operation: A `PSOperation` instance the has just been finished executing.
     - Parameter errors: An array of `NSError` returned by an operation while finishing.
     */
    func operationDidFinish(_ operation: PSOperation, errors: [NSError]) {
        if let error = operation.errors.first, error.domain == "io.realm.sync", error.code ==  611 {
            DispatchQueue.main.async {
                self.register?.emailErrorLabel.text = "User already exists"
            }
        }
    }
}
