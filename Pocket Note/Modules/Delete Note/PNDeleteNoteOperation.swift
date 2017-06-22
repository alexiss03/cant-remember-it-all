//
//  PNDeleteNoteOperation.swift
//  Memo
//
//  Created by Hanet on 6/21/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import ProcedureKit
import RealmSwift

class PNDeleteNoteOperation: Procedure, InputProcedure {
    private var realm: Realm?
    internal var input: Pending<Note> = .pending
    
    public required init(realm: Realm) {
        self.realm = realm
        
        super.init()
    }
    
    public override func execute() {
        guard let unwrappedRealm = realm, let unwrappedNoteToBeDeleted = input.value else {
            return
        }
        
        DispatchQueue.main.async {
            do {
                try unwrappedRealm.write {
                    unwrappedRealm.delete(unwrappedNoteToBeDeleted)
                }
            } catch { }
        }
    }
}
