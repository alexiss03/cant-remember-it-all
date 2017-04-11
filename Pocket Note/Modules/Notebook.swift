//
//  Notebook.swift
//  Pocket Note
//
//  Created by Hanet on 4/10/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Foundation
import RealmSwift

class Notebook: Object {
    dynamic var name: String?
    var notes: List<Note>?
    dynamic var dateCreated: Date?
    dynamic var notebookId: String?
    dynamic var account: Account?
    
    override static func primaryKey() -> String? {
        return "notebookId"
    }
}
