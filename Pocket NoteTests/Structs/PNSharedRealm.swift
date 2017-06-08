//
//  RealmConstants.swift
//  Memo
//
//  Created by Hanet on 5/25/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import RealmSwift

struct PNSharedRealm {
    static let syncHost = "54.245.131.159"
    static let authenticationServerURL = URL(string:"http://54.245.131.159:9080/")!
    
    static let syncRealmPath = "realmtasks"
    static let defaultListName = "My Tasks"
    static let defaultListID = "80EB1620-165B-4600-A1B1-D97032FDD9A0"
    
    static let userServerURL = URL(string: "realm://\(syncHost):9080/~/\(syncRealmPath)")
}
