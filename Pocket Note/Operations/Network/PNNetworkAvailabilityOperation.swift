//
//  PNNetworkAvailabilityOperation.swift
//  Memo
//
//  Created by Hanet on 5/25/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import PSOperations
import ProcedureKit

/** 
 This operation checks for the availability of the connection to a network
*/
public class PNNetworkAvailabilityInteractor: Procedure, PSOperationQueueDelegate {
    // This is the name of the operation
    public static let name = "Network Availability"
    
    /**
     This is the initialization method.
     */
    public override init() {
        super.init()
    }
    
    /**
     This is the execution of the business logic of the operation. If the device is connected to a network. If the device is connected, the operation finishes with no error. Else, if the finishes the operation with a no network error.
     */
    override public func execute() {
        if Reachability.isConnectedToNetwork() {
            self.finish()
        } else {
            self.finish(withError: PNNetworkAvailabilityInteractor.noNetworkError)
        }
    }
}
 
extension PNNetworkAvailabilityInteractor {
    /** 
        Error if there is no network connection.
    */
    static let noNetworkError = NSError.init(domain: "error.network.no.network", code: 1000, userInfo: nil)
}
