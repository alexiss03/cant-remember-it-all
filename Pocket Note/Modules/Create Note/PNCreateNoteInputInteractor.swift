//
//  PNNewNoteValidation.swift
//  Memo
//
//  Created by Hanet on 6/19/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import ProcedureKit
/**
 This `OperationCondition` creates the condition for new note content.
 */
class PNCreateNoteInputInteractor: Procedure, OutputProcedure {
    /// A `String` value indicating the name of the operation.
    private static let name = "New Note Content"
    /// A `Boolean` value indicating if multiple instances of the conditionalized operation is permitted.
    private static let isMutuallyExclusive = false
    /// A `String` value indicating the content of the new note.
    private var content: String?
    private var note: Note?
    var output: Pending<ProcedureResult<String>> = .pending
    
    /**
     Initializes the instance.
     
     - Parameter content: The content of the new note to be created.
     */
    init(content: String?, note: Note?) {
        self.content = content
        self.note = note
        super.init()
    }
    
    override func execute() {
        DispatchQueue.main.async {
            if let unwrappedNote = self.note, unwrappedNote.body == self.content {
                let error = NSError.init(domain: PNCreateNoteErrorDomain, code: 0000, userInfo: nil)
                self.cancel(withError: error)
            } else if let unwrappedContent = self.content, unwrappedContent.characters.count > 0 {
                self.finish(withResult: .success(unwrappedContent))
            } else {
                let error = NSError.init(domain: PNCreateNoteErrorDomain, code: 0001, userInfo: nil)
                self.cancel(withError: error)
            }

        }
    }
}
