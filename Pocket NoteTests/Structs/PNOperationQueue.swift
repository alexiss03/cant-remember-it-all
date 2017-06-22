//
//  OperationQueue.swift
//  Memo
//
//  Created by Hanet on 6/2/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import PSOperations
import ProcedureKit

struct PNOperationQueue {
    static let networkOperationQueue = PSOperationQueue()
    static let realmOperationQueue = ProcedureQueue()
}
