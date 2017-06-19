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
    
    static let syncServerURL = URL(string: "realm://\(syncHost):9080/~/\(syncRealmPath)")
    
    static func configureDefaultRealm() -> Realm? {
        guard let user = SyncUser.current else {
            var realm: Realm?
            
            do {
                realm = try Realm()
            } catch { }
            
            return realm
        }
        
        let realm = configureRealm(user: user)
        return realm
    }
    
    static func configureRealm(user: SyncUser?) -> Realm? {
        guard let user = user else {
            var realm: Realm?
            
            do {
                realm = try Realm()
            } catch { }
            
            return realm
        }
        
        guard let syncServerURL = PNSharedRealm.syncServerURL else {
            return nil
        }
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            syncConfiguration: SyncConfiguration(user: user, realmURL: syncServerURL),
            objectTypes: [Account.self, Note.self, Notebook.self]
        )
        
        var realm: Realm?
        
        do {
            realm = try Realm()
        } catch { }
        
        return realm
    }
    
    static func realmInstance() -> Realm? {
        var realm: Realm?
        
        do {
            realm = try Realm()
        } catch { }
        
        return realm
    }
}
