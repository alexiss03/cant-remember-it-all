//
//  PNNewNoteValidation.swift
//  Memo
//
//  Created by Hanet on 6/19/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import PSOperations
/**
 This `OperationCondition` creates the condition for new note content.
 */
struct PNNewNoteContentCondition: OperationCondition {
    /// A `String` value indicating the name of the operation.
    static let name = "New Note Content"
    /// A `Boolean` value indicating if multiple instances of the conditionalized operation is permitted.
    static let isMutuallyExclusive = false
    /// A `String` value indicating the content of the new note.
    var content: String
    
    /**
     Initializes the instance.
     
     - Parameter content: The content of the new note to be created.
     */
    init(content: String) {
        self.content = content
    }
    
    func dependencyForOperation(_ operation: PSOperation) -> Foundation.Operation? {
        return nil
    }
    
    func evaluateForOperation(_ operation: PSOperation, completion: @escaping (OperationConditionResult) -> Void) {
        if content.characters.count > 0 {
            completion(.satisfied)
        } else {
            let error = NSError(code: .conditionFailed, userInfo: [
            OperationConditionKey: type(of: self).name])
            completion(.failed(error))
        }
    }
}
