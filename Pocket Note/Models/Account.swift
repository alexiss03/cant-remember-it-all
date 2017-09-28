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
    @objc dynamic var username: String?
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var password: String?
    @objc dynamic var accountId: String? = UUID.init().uuidString

    override static func primaryKey() -> String? {
        return "accountId"
    }
}
