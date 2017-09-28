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
    @objc dynamic var bodyMarkDown: Data?
    @objc dynamic var body: String?
    @objc dynamic var title: String?
    @objc dynamic var dateCreated: Date?
    @objc dynamic var dateUpdated: Date?
    @objc dynamic var notebook: Notebook?
    @objc dynamic var noteId: String?
    @objc dynamic var account: Account?

    override static func primaryKey() -> String? {
        return "noteId"
    }
}
