//
//  AccountModelTestCase.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 4/11/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import Quick
import Nimble

@testable import Pocket_Note

import RealmSwift

class AccountModelQuickSpec: QuickSpec {
    var realm: Realm?
    
    override func spec() {
        beforeEach {
            do {
                self.realm = try Realm()
                
                guard let unwrappedRealm = self.realm else { return }
                try unwrappedRealm.write {
                    self.realm?.deleteAll()
                }
            } catch { }
        }
        
        describe("operation on Account") {
            it("insertion") {
                guard let unwrappedRealm = self.realm else { return }
                
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
                expect(newAccount).notTo(beNil())
            }
            
            describe("updating") {
                it("first name") {
                    guard let unwrappedRealm = self.realm else { return }
                    
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
                    expect(updatedAccount?.firstName).to(equal("This is an updated first name"))
                }
                
                it("last name") {
                    guard let unwrappedRealm = self.realm else { return }
                    
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
                            let values =  ["accountId": "ACCOUNT01", "lastName": "This is an updated last name."]
                            _ = unwrappedRealm.create(Account.self, value: values, update: true)
                        }
                    } catch { }
                    
                    let updatedAccount = unwrappedRealm.objects(Account.self).filter("accountId = 'ACCOUNT01'").first
                    expect(updatedAccount?.lastName).to(equal("This is an updated last name."))

                }
                
                it("password") {
                    guard let unwrappedRealm = self.realm else { return }
                    
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
                    expect(updatedAccount?.password).to(equal("This is an updated password"))
                }
            }
            
        }
    }

}
