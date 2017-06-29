//
//  PNInvalidLoginErrorObserver.swift
//  Memo
//
//  Created by Hanet on 5/30/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import PSOperations

/**
 The`PNInvalidLoginErrorObserver` struct observes the errors returned by login operations.
 */
struct PNInvalidLoginErrorObserver: OperationObserver {
    /// A `PNLoginViewProtocol` containing the emailErrorLabel where the error message can be displayed.
    private weak var loginView: PNLoginViewProtocol?
    
    /**
     Initializes the instance.
     
     - Parameter loginView: A `PNLoginViewProtocol` containing the emailErrorLabel where the error message can be displayed.
     */
    init(loginView: PNLoginViewProtocol) {
        self.loginView = loginView
    }
    
    internal func operationDidStart(_ operation: PSOperation) { }
    
    internal func operationDidCancel(_ operation: PSOperation) { }
    
    internal func operation(_ operation: PSOperation, didProduceOperation newOperation: Foundation.Operation) { }
    
    /**
     Handles the login error by an operation being observed.
     
     - Parameter operation: A `PSOperation` instance being observed.
     - Parameter errors: An array of `NSError` returned by an operation being observed while finishing.
     */
    internal func operationDidFinish(_ operation: PSOperation, errors: [NSError]) {
        if let error = operation.errors.first, error.domain == "io.realm.sync", error.code ==  611 {
            DispatchQueue.main.async {
                self.loginView?.emailErrorLabel.text = "Invalid login credentials or user does not exists"
            }
        }
    }
}
