//
//  Note.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 4/10/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Foundation
import RealmSwift

class Note: Object {
    dynamic var body: String?
    dynamic var title: String?
    dynamic var dateCreated: Date?
    dynamic var notebook: Notebook?
    dynamic var noteId: String?
    dynamic var account: Account?

    override static func primaryKey() -> String? {
        return "noteId"
    }
}
