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
        do { realm = try Realm() } catch {}
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddAccount() {
        guard let unwrappedRealm = realm else { return }
        
        let account = Account()
        account.id = "ACCOUNT01"
        account.username = "USERNAME01"
        account.firstName = "This is a first name"
        account.lastName = "This is a last name"
        account.password = "This is a password"
        
        try! unwrappedRealm.write(){
            unwrappedRealm.add(account)
        }
        
        let newAccount = unwrappedRealm.objects(Note.self).filter("id = 'ACCOUNT01'").first
        XCTAssertNotNil(newAccount)
    }
    
    func testUpdateFirstName() {
        guard let unwrappedRealm = realm else { return }
        
        let account = Account()
        account.id = "ACCOUNT01"
        account.username = "USERNAME01"
        account.firstName = "This is a first name"
        account.lastName = "This is a last name"
        account.password = "This is a password"
        
        try! unwrappedRealm.write(){
            unwrappedRealm.add(account)
        }
        
        try! unwrappedRealm.write(){
            _ = unwrappedRealm.create(Notebook.self, value: ["id":"ACCOUNT01", "firstName":"This is an updated first name"], update: true)
        }
        
        let updatedNote = unwrappedRealm.objects(Account.self).filter("id = 'ACCOUNT01'").first
        XCTAssertEqual(updatedNote?.firstName, "This is an updated first name")
    }
    
    func testUpdateLastName() {
        guard let unwrappedRealm = realm else { return }
        
        let account = Account()
        account.id = "ACCOUNT01"
        account.username = "USERNAME01"
        account.firstName = "This is a first name"
        account.lastName = "This is a last name"
        account.password = "This is a password"
        
        try! unwrappedRealm.write(){
            unwrappedRealm.add(account)
        }
        
        try! unwrappedRealm.write(){
            _ = unwrappedRealm.create(Notebook.self, value: ["id":"ACCOUNT01", "lastName":"This is an updated last name"], update: true)
        }
        
        let updatedNote = unwrappedRealm.objects(Account.self).filter("id = 'ACCOUNT01'").first
        XCTAssertEqual(updatedNote?.lastName, "This is an updated last name")
        
    }
    
    func testUpdatePassword() {
        guard let unwrappedRealm = realm else { return }
        
        let account = Account()
        account.id = "ACCOUNT01"
        account.username = "USERNAME01"
        account.firstName = "This is a first name"
        account.lastName = "This is a last name"
        account.password = "This is a password"
        
        try! unwrappedRealm.write(){
            unwrappedRealm.add(account)
        }
        
        try! unwrappedRealm.write(){
            _ = unwrappedRealm.create(Notebook.self, value: ["id":"ACCOUNT01", "password":"This is an updated password"], update: true)
        }
        
        let updatedNote = unwrappedRealm.objects(Account.self).filter("id = 'ACCOUNT01'").first
        XCTAssertEqual(updatedNote?.password, "This is an updated password")
    }
}
