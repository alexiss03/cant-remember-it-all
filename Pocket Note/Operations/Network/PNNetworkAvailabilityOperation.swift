//
//  PNNetworkAvailabilityOperation.swift
//  Memo
//
//  Created by Hanet on 5/25/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import PSOperations

public class PNNetworkAvailabilityOperation: PSOperation, PSOperationQueueDelegate {
    
    public static let name = "Network Availability"
    public override init() { }
    
    override public func execute() {
        if Reachability.isConnectedToNetwork() {
            self.finish()
        } else {
            self.cancelWithError(PNNetworkAvailabilityOperation.noNetworkError)
        }
    }
}
 
extension PNNetworkAvailabilityOperation {
    static let noNetworkError = NSError.init(domain: "error.network.no.network", code: 1000, userInfo: nil)
}
