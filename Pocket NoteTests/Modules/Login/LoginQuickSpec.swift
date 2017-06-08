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
        
        describe("registration") {
            describe("email input") {
                it("empty") {
                    vc?.baseView?.emailTextField.text = ""
                    vc?.baseView?.delegate?.loginButtonTapped()
                    expect(vc?.baseView?.emailErrorLabel.text).notTo(equal(""))
                }
                
                describe("invalid format") {
                    it("no @") {
                        vc?.baseView?.emailTextField.text = "aa"
                        vc?.baseView?.delegate?.loginButtonTapped()
                        expect(vc?.baseView?.emailErrorLabel.text).notTo(equal(""))
                        
                    }
                    
                    it("no .") {
                        vc?.baseView?.emailTextField.text = "a@a"
                        vc?.baseView?.delegate?.loginButtonTapped()
                        expect(vc?.baseView?.emailErrorLabel.text).notTo(equal(""))
                    }
                }
                
                it("valid format") {
                    vc?.baseView?.emailTextField.text = "a@a.com"
                    vc?.baseView?.delegate?.loginButtonTapped()
                    expect(vc?.baseView?.emailErrorLabel.text).to(equal(""))
                }
            }
            
            describe("password input") {
                it("empty") {
                    vc?.baseView?.passwordTextField.text = ""
                    vc?.baseView?.delegate?.loginButtonTapped()
                    expect(vc?.baseView?.passwordErrorLabel.text).notTo(equal(""))
                }
                
                it("too short min 6") {
                    vc?.baseView?.passwordTextField.text = "1234"
                    vc?.baseView?.delegate?.loginButtonTapped()
                    expect(vc?.baseView?.passwordErrorLabel.text).notTo(equal(""))
                }
                
                it("too long max 30") {
                    vc?.baseView?.passwordTextField.text = "1234567890123456789012345678901"
                    vc?.baseView?.delegate?.loginButtonTapped()
                    expect(vc?.baseView?.passwordErrorLabel.text).notTo(equal(""))
                }
                
                describe("valid") {
                    it("6 characters") {
                        vc?.baseView?.passwordTextField.text = "123456"
                        vc?.baseView?.delegate?.loginButtonTapped()
                        expect(vc?.baseView?.passwordErrorLabel.text).to(equal(""))
                    }
                    
                    it("30 characters") {
                        vc?.baseView?.passwordTextField.text = "123456789012345678901234567890"
                        vc?.baseView?.delegate?.loginButtonTapped()
                        expect(vc?.baseView?.passwordErrorLabel.text).to(equal(""))
                    }
                }
            }
            
            describe("account") {
                it("valid email and password") {
                    vc?.baseView?.emailTextField.text = "admin@memo.com"
                    vc?.baseView?.passwordTextField.text = "password"
                    vc?.baseView?.delegate?.loginButtonTapped()
                    
                    guard let username = vc?.baseView?.emailTextField.text else {
                        print("Username is empty")
                        return
                    }
                    
                    guard let password = vc?.baseView?.passwordTextField.text else {
                        print("Password is empty")
                        return
                    }
                    
                    guard let unwrappedVC = vc else {
                        print("View Controller is nil")
                        return
                    }
                    
                    let loginOperation = PNLoginUserOperation.init(username: username, password: password, nextViewController: unwrappedVC)
                    PNOperationQueue.networkOperationQueue.addOperation(loginOperation)

                    expect(unwrappedVC.isBeingPresented).to(equal(false))
                    expect(vc?.baseView?.emailErrorLabel.text).to(equal(""))
                }
    
            }
            
            it("no internet connection") {
//                 guard let unwrappedVC = vc else {
//                    print("View Controller is nil")
//                    return
//                 }
//                 vc?.baseView?.emailTextField.text = "user2@domain.com"
//                 vc?.baseView?.passwordTextField.text = "123456"
//                 vc?.baseView?.delegate?.loginButtonTapped()
//                 self.stub(everything, http(404))
//                
//                guard let username = vc?.baseView?.emailTextField.text else {
//                    print("Username is empty")
//                    return
//                }
//                
//                guard let password = vc?.baseView?.passwordTextField.text else {
//                    print("Password is empty")
//                    return
//                }
//                
//                let loginOperation = PNLoginUserOperation.init(username: username, password: password, nextViewController: unwrappedVC)
//                PNOperationQueue.networkOperationQueue.addOperation(loginOperation)
            }
            
            it("slow internet connection") {
                
            }

        }
    }
}
