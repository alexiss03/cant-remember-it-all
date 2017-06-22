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
    private var filter: NSPredicate
    
    internal var output: Pending<ProcedureResult<Note>> = .pending
    
    public required init(indexPath: IndexPath, filter: NSPredicate, realm: Realm) {
        self.indexPath = indexPath
        self.realm = realm
        self.filter = filter
        super.init()
    }
    
    public override func execute() {
        DispatchQueue.main.async {
            let noteList = self.realm.objects(Note.self).filter(self.filter).sorted(byKeyPath: "dateUpdated", ascending: false)
            
            if self.indexPath.row < noteList.count {
                let note = noteList[self.indexPath.row]
                self.finish(withResult: .success(note))
            } else {
                self.output = .ready(.failure(ProcedureKitError.requirementNotSatisfied()))
            }
        }
    }
}
