//
//  PNFetchNoteOperation.swift
//  Memo
//
//  Created by Hanet on 6/21/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import ProcedureKit
import RealmSwift

/**
 The `PNFetchNoteOperation` class subclasses `Procedure` and implements `OutputProcedure`.
 
 This fetches a note from using a filter and an indexpath.
 */
class PNFetchNoteOperation: Procedure, OutputProcedure {
    /// An `IndexPath` instance to identify the position of the note in the result.
    private var indexPath: IndexPath
    /// A `Realm` to where the note is to be fetched.
    private var realm: Realm
    /// A 'NSPredicate' that filters the list of notes from the specified realm
    private var filter: NSPredicate?
    /// A `Pending<ProcedureResult<Note>>` that outputs the fetched note to the next operation in queue.
    var output: Pending<ProcedureResult<Note>> = .pending
    
    /**
     Initializes the instance.
     
     - Parameter indexPath: An `IndexPath` instance to identify the position of the note in the result.
     - Parameter filter: A 'NSPredicate' that filters the list of notes from the specified realm
     - Parameter realm: A `Realm` to where the note is to be fetched.
     */
    public required init(indexPath: IndexPath, filter: NSPredicate? = nil, realm: Realm) {
        self.indexPath = indexPath
        self.realm = realm
        self.filter = filter
        super.init()
    }
    
    /**
     Contains the main execution of the operation.
     
     First, it selects the list of notes with the set filter. Then, A row from the result is selected using the indexpath.
     */
    public override func execute() {
        DispatchQueue.main.async {
            var noteList: Results<Note>
            
            if let filter = self.filter {
                noteList = self.realm.objects(Note.self).filter(filter).sorted(byKeyPath: "dateUpdated", ascending: false)
            } else {
                noteList = self.realm.objects(Note.self).sorted(byKeyPath: "dateUpdated", ascending: false)
            }
            
            if self.indexPath.row < noteList.count {
                let note = noteList[self.indexPath.row]
                self.finish(withResult: .success(note))
            } else {
                self.output = .ready(.failure(ProcedureKitError.requirementNotSatisfied()))
            }
        }
    }
}
