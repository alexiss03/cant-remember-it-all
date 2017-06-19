//
//  PNNewNoteValidation.swift
//  Memo
//
//  Created by Hanet on 6/19/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import PSOperations

struct PNNewNoteContentCondition: OperationCondition {
    static let name = "New Note Content"
    static let isMutuallyExclusive = false
    var content: String?
    
    init(content: String?) {
        self.content = content
    }
    
    func dependencyForOperation(_ operation: PSOperation) -> Foundation.Operation? {
        return nil
    }
    
    func evaluateForOperation(_ operation: PSOperation, completion: @escaping (OperationConditionResult) -> Void) {
        if let unwrappedContent = content, unwrappedContent.characters.count > 0 {
            completion(.satisfied)
        } else {
            let error = NSError(code: .conditionFailed, userInfo: [
            OperationConditionKey: type(of: self).name])
            completion(.failed(error))
        }
    }
}
