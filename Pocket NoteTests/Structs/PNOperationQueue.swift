//
//  OperationQueue.swift
//  Memo
//
//  Created by Hanet on 6/2/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import PSOperations
import ProcedureKit

/**
 The `PNOperationQueue` struct serves as the containers for the operation queue to be used throughout the application
 */
struct PNOperationQueue {
    /// A  `PSOperationQueue` instance to receive `PSOperation`s.
    static let networkOperationQueue = PSOperationQueue()
    /// A `ProcedureQueue` instance to receive `Procedure`s
    static let realmOperationQueue = ProcedureQueue()
}
