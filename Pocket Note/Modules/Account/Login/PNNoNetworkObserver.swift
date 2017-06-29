//
//  PSNoNetworkObserver.swift
//  Memo
//
//  Created by Hanet on 5/25/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import PSOperations

/**
 The `PNNoNetworkObserver` class observes to the availabiltiy of the network. If no network is detected, it presents an alert controller to the specified presentation contextt.
 */
struct PNNoNetworkObserver: OperationObserver {
    /// A `UIViewController` instance presenting a possible alert controller when no internet connection is detected.
    private var presentationContext: UIViewController
    
    /**
     Initializes the instance. 
     
     - Parameter presentationContext: A `UIViewController` instance presenting a possible alert controller when no internet connection is detected.
     */
    init(presentationContext: UIViewController) {
        self.presentationContext = presentationContext
    }
    
    internal func operationDidStart(_ operation: PSOperation) { }
    
    internal func operationDidCancel(_ operation: PSOperation) { }
    
    internal func operation(_ operation: PSOperation, didProduceOperation newOperation: Foundation.Operation) { }

    /**
     Handles the errors thrown when an operation being observed has finished with an error.
     
     - Parameter operation: An `PSOperation` instance being observed.
     - Parameter errors: An array of `NSError` returned by an operation being observed while finishing.
     */
    func operationDidFinish(_ operation: PSOperation, errors: [NSError]) {
        if let error = errors.first, error.domain == "error.network.no.network" {
            let alertControlller = UIAlertController.init(title: "No Internet Connection", message: "Cannot proceed with this action. Please connect to a network to continue.", preferredStyle: .alert)
            let okButton = UIAlertAction.init(title: "Ok", style: .cancel) { (_) in
                alertControlller.dismiss(animated: true, completion: nil)
            }
            alertControlller.addAction(okButton)
            presentationContext.present(alertControlller, animated: true, completion: nil)
        }
    }
    
}
