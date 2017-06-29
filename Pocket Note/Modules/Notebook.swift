//
//  Notebook.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 4/10/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Foundation
import RealmSwift

/**
 The `Notebook` class represents a notebook. A notebook can be created, updated, and deleted. A notebook can contain any number of notebooks.
 */
class Notebook: Object {
    dynamic var name: String?
    dynamic var dateCreated: Date?
    dynamic var notebookId: String?
    let notes = LinkingObjects(fromType: Note.self, property: "notebook")

    override static func primaryKey() -> String? {
        return "notebookId"
    }
}
