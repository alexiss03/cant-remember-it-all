//
//  Account.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 4/11/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import Foundation
import RealmSwift

class Account: Object {
    dynamic var username: String?
    dynamic var firstName: String?
    dynamic var lastName: String?
    dynamic var password: String?
    dynamic var accountId: String? = UUID.init().uuidString

    override static func primaryKey() -> String? {
        return "accountId"
    }
}
