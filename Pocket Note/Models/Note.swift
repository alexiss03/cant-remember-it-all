//
//  Note.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 4/10/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Foundation
import RealmSwift
import ProcedureKit

/**
 The `Note` class represents a note. A note can be created, updated, and be deleted.
 A note also can belong to one note, but is not required. It can also be moved from one note to another.
 */
class Note: Object {
    dynamic var body: String?
    dynamic var title: String?
    dynamic var dateCreated: Date?
    dynamic var dateUpdated: Date?
    dynamic var notebook: Notebook?
    dynamic var noteId: String?
    dynamic var account: Account?

    override static func primaryKey() -> String? {
        return "noteId"
    }
}
