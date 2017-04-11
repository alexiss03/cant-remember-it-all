//
//  AccountModelTestCase.swift
//  Pocket Note
//
//  Created by Hanet on 4/11/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Pocket_Note

class AccountModelTestCase: XCTestCase {
    
    var realm: Realm?
    
    override func setUp() {
        do {
            realm = try Realm()

            guard let unwrappedRealm = realm else { return }
            try unwrappedRealm.write {
                realm?.deleteAll()
            }
        } catch { }
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddAccount() {
        guard let unwrappedRealm = realm else { return }
        
        let account = Account()
        account.accountId = "ACCOUNT01"
        account.username = "USERNAME01"
        account.firstName = "This is a first name"
        account.lastName = "This is a last name"
        account.password = "This is a password"
        
        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(account)
            }
        } catch { }
        
        let newAccount = unwrappedRealm.objects(Account.self).filter("accountId = 'ACCOUNT01'").first
        XCTAssertNotNil(newAccount)
    }
    
    func testUpdateFirstName() {
        guard let unwrappedRealm = realm else { return }
        
        let account = Account()
        account.accountId = "ACCOUNT01"
        account.username = "USERNAME01"
        account.firstName = "This is a first name"
        account.lastName = "This is a last name"
        account.password = "This is a password"
        
        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(account)
            }
            
            try unwrappedRealm.write {
                let values = ["accountId": "ACCOUNT01", "firstName": "This is an updated first name"]
                _ = unwrappedRealm.create(Account.self, value: values, update: true)
            }

        } catch { }
        
        let updatedAccount = unwrappedRealm.objects(Account.self).filter("accountId = 'ACCOUNT01'").first
        XCTAssertEqual(updatedAccount?.firstName, "This is an updated first name")
    }
    
    func testUpdateLastName() {
        guard let unwrappedRealm = realm else { return }
        
        let account = Account()
        account.accountId = "ACCOUNT01"
        account.username = "USERNAME01"
        account.firstName = "This is a first name"
        account.lastName = "This is a last name"
        account.password = "This is a password"
        
        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(account)
            }
        } catch { }
        
        do {
            try unwrappedRealm.write {
                let values =  ["accountId": "ACCOUNT01", "lastName": "This is an updated last name"]
                _ = unwrappedRealm.create(Account.self, value: values, update: true)
            }
        } catch { }
        
        let updatedAccount = unwrappedRealm.objects(Account.self).filter("accountId = 'ACCOUNT01'").first
        XCTAssertEqual(updatedAccount?.lastName, "This is an updated last name")
        
    }
    
    func testUpdatePassword() {
        guard let unwrappedRealm = realm else { return }
        
        let account = Account()
        account.accountId = "ACCOUNT01"
        account.username = "USERNAME01"
        account.firstName = "This is a first name"
        account.lastName = "This is a last name"
        account.password = "This is a password"
        
        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(account)
            }
        } catch { }
        
        do {
            try unwrappedRealm.write {
                let values =  ["accountId": "ACCOUNT01", "password": "This is an updated password"]
                _ = unwrappedRealm.create(Account.self, value: values, update: true)
            }
        } catch { }
        
        let updatedAccount = unwrappedRealm.objects(Account.self).filter("accountId = 'ACCOUNT01'").first
        XCTAssertEqual(updatedAccount?.password, "This is an updated password")
    }
}
