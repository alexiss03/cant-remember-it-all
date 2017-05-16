//
//  ASNetworkAvailabilityCondition.swift
//  Pocket Note
//
//  Created by Hanet on 5/16/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import PSOperations

public struct ASNetworkAvailabilityCondition: OperationCondition {
    
    public static let name = "Network Availability"
    public static let isMutuallyExclusive = true
    
    public init() { }

    public func dependencyForOperation(_ operation: PSOperations.Operation) -> Foundation.Operation? {
        return nil
    }

    public func evaluateForOperation(_ operation: PSOperations.Operation, completion: @escaping (PSOperations.OperationConditionResult) -> Swift.Void) {
        
    }
    
}
