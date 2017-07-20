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
class PNDeleteNoteOperation: Procedure {
    /// A `Realm` where the note is to be deleted.
    private var selectedNote: Note
    /// A `Pending<Note>` that contains the note to be deleted.
    internal var input: Pending<Note> = .pending
    
    /**
     Initializes the instance.
     
     - Parameter realm:  A `Realm` where the note is to be deleted.
     */
    public required init(selectedNote: Note) {
        self.selectedNote = selectedNote
        super.init()
    }
    
    /**
     Contains the execution of the operation.
     
     This is where the note is deleted in the realm specified.
     */
    public override func execute() {
        DispatchQueue.main.async {
            do {
                try self.selectedNote.realm?.write {
                    self.selectedNote.realm?.delete(self.selectedNote)
                }
            } catch { }
        }
    }
}
