//
//  PNFetchNoteOperation.swift
//  Memo
//
//  Created by Hanet on 6/21/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import ProcedureKit
import RealmSwift

class PNFetchNoteOperation: Procedure, OutputProcedure {
    private var indexPath: IndexPath
    private var realm: Realm
    private var filter: NSPredicate?
    
    internal var output: Pending<ProcedureResult<Note>> = .pending
    
    public required init(indexPath: IndexPath, filter: NSPredicate? = nil, realm: Realm) {
        self.indexPath = indexPath
        self.realm = realm
        self.filter = filter
        super.init()
    }
    
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
