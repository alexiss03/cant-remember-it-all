//
//  PNExistingUserAlreadyErrorObserver.swift
//  Memo
//
//  Created by Hanet on 5/30/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import PSOperations

struct PNExistingUserAlreadyErrorObserver: OperationObserver {
    weak var register: PNRegistrationViewProtocol?
    
    init(register: PNRegistrationViewProtocol) {
        self.register = register
    }
    
    func operationDidStart(_ operation: PSOperation) {
    }
    
    func operationDidCancel(_ operation: PSOperation) {
        
    }
    
    func operation(_ operation: PSOperation, didProduceOperation newOperation: Foundation.Operation) {
        
    }
    
    func operationDidFinish(_ operation: PSOperation, errors: [NSError]) {
        if let error = operation.errors.first, error.domain == "io.realm.sync", error.code ==  611 {
            DispatchQueue.main.async {
                self.register?.emailErrorLabel.text = "User already exists"
            }
        }
    }
}
