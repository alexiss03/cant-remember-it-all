//
//  LoginQuickSpec.swift
//  Pocket Note
//
//  Created by Hanet on 5/8/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Quick
import Nimble

import RealmSwift
import UIKit

@testable import Memo

class LoginQuickSpec: QuickSpec {
    override func spec() {
        var vc: PNLoginViewController? = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "PNLoginViewController") as? PNLoginViewController
        var realm: Realm?
        
        beforeEach {
            vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "PNLoginViewController") as? PNLoginViewController
            vc?.loadViewProgrammatically()
            
            do {
                realm = try Realm()
                
                guard let unwrappedRealm = realm else { return }
                try unwrappedRealm.write {
                    realm?.deleteAll()
                }
                
                let account = Account()
                account.accountId = "ACCOUNT01"
                account.username = "user@domain.com"
                account.firstName = "This is a first name"
                account.lastName = "This is a last name"
                account.password = "123456"
                
                try unwrappedRealm.write {
                    unwrappedRealm.add(account)
                }
            } catch { }
            
        }
        
        describe("login") {
            describe("email input") {
                it("empty") {
                    vc?.baseView?.eventHandler?.login(emailText: "", passwordText: "123456")
                    expect(vc?.baseView?.emailErrorLabel.text).toEventually(equal(""))
                }
                
                describe("invalid format") {
                    it("no @") {
                        vc?.baseView?.eventHandler?.login(emailText: "aa", passwordText: "123456")
                        expect(vc?.baseView?.emailErrorLabel.text).toNotEventually(equal(""))
                        
                    }
                    
                    it("no .") {
                        vc?.baseView?.eventHandler?.login(emailText: "a@a", passwordText: "123456")
                        expect(vc?.baseView?.emailErrorLabel.text).toNotEventually(equal(""))
                    }
                }
                
                it("valid format") {
                    vc?.baseView?.eventHandler?.login(emailText: "a@a.com", passwordText: "123456")
                    expect(vc?.baseView?.emailErrorLabel.text).to(equal(""))
                }
            }
            
            describe("password input") {
                it("empty") {
                    vc?.baseView?.eventHandler?.login(emailText: "a@a.com", passwordText: "")
                    expect(vc?.baseView?.passwordErrorLabel.text).toEventually(equal(""))
                }
                
                it("too short min 6") {
                    vc?.baseView?.eventHandler?.login(emailText: "a@a.com", passwordText: "1234")
                    expect(vc?.baseView?.passwordErrorLabel.text).toEventually(equal(""))
                }
                
                it("too long max 30") {
                    vc?.baseView?.eventHandler?.login(emailText: "a@a.com", passwordText: "1234567890123456789012345678901")
                    expect(vc?.baseView?.passwordErrorLabel.text).toEventually(equal(""))
                }
                
                describe("valid") {
                    it("6 characters") {
                        vc?.baseView?.eventHandler?.login(emailText: "a@a.com", passwordText: "123456")
                        expect(vc?.baseView?.passwordErrorLabel.text).to(equal(""))
                    }
                    
                    it("30 characters") {
                        vc?.baseView?.eventHandler?.login(emailText: "a@a.com", passwordText: "123456789012345678901234567890")
                        expect(vc?.baseView?.passwordErrorLabel.text).toEventually(equal(""))
                    }
                }
            }
            
            describe("account") {
                it("valid email and password") {
                    vc?.baseView?.emailTextField.text = "user@domain.com"
                    vc?.baseView?.passwordTextField.text = "123456"
                    vc?.baseView?.eventHandler?.login(emailText: "admin@memo.com", passwordText: "password")
                    
                    guard let unwrappedVC = vc else {
                        print("View Controller is nil")
                        return
                    }
                    
                    expect(unwrappedVC.isBeingPresented).to(equal(false))
                    expect(unwrappedVC.baseView?.emailErrorLabel.text).to(equal(""))
                }
            }

        }
    }
}
