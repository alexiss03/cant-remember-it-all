//
//  PNDeleteNoteOperation.swift
//  Memo
//
//  Created by Hanet on 6/21/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import ProcedureKit
import RealmSwift

/**
 The `PNDeleteNoteOperation` that subclases  `Procedure` and implements `InputProcedure` to delete an specified note in a specified realm.
 */
class PNDeleteNoteOperation: Procedure, InputProcedure {
    /// A `Realm` where the note is to be deleted.
    private var realm: Realm
    /// A `Pending<Note>` that contains the note to be deleted.
    internal var input: Pending<Note> = .pending
    
    /**
     Initializes the instance.
     
     - Parameter realm:  A `Realm` where the note is to be deleted.
     */
    public required init(realm: Realm) {
        self.realm = realm
        super.init()
    }
    
    /**
     Contains the execution of the operation.
     
     This is where the note is deleted in the realm specified.
     */
    public override func execute() {
        guard let unwrappedNoteToBeDeleted = input.value else {
            return
        }
        
        weak var weakSelf = self
        DispatchQueue.main.async {
            guard let strongSelf = weakSelf else {
                print("Weak self is nil")
                return
            }
            
            do {
                try strongSelf.realm.write {
                    strongSelf.realm.delete(unwrappedNoteToBeDeleted)
                }
            } catch { }
        }
    }
}
