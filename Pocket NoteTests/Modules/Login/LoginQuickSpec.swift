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
    class MockPNLoginViewController: PNLoginViewController {
        override func viewDidLoad() {
            baseView = Bundle.main.loadNibNamed("PNLoginView", owner: self, options: nil)![0] as? PNLoginView
            super.viewDidLoad()
        }
    }
    
    override func spec() {
        var vc = MockPNLoginViewController()
        var realm: Realm?
        
        beforeEach {
            vc = MockPNLoginViewController()
            vc.loadViewProgrammatically()
            
            do {
                realm = try Realm()
                
                guard let unwrappedRealm = realm else { return }
                try unwrappedRealm.write {
                    realm?.deleteAll()
                }
                
            } catch { }
            
        }
        
        describe("login") {
            it("email input") {
                vc.baseView?.eventHandler?.login(emailText: "", passwordText: "123456")
                expect(vc.baseView?.getEmailErrorText()).toNotEventually(equal(""))
            }
        
            describe("invalid format") {
                it("no @") {
                    vc.baseView?.eventHandler?.login(emailText: "aa", passwordText: "123456")
                    expect(vc.baseView?.getEmailErrorText()).toNotEventually(equal(""))
                    
                }
                
                it("no .") {
                    vc.baseView?.eventHandler?.login(emailText: "a@a", passwordText: "123456")
                    expect(vc.baseView?.getEmailErrorText()).toNotEventually(equal(""))
                }
                
                it("valid format") {
                    vc.baseView?.eventHandler?.login(emailText: "a@a.com", passwordText: "123456")
                    expect(vc.baseView?.getEmailErrorText()).to(equal(""))
                }
            }
        
            describe("password input") {
                it("empty") {
                    vc.baseView?.eventHandler?.login(emailText: "a@a.com", passwordText: "")
                    expect(vc.baseView?.getPasswordErrorText()).toNotEventually(equal(""))
                }
                
                it("too short min 6") {
                    vc.baseView?.eventHandler?.login(emailText: "a@a.com", passwordText: "1234")
                    expect(vc.baseView?.getPasswordErrorText()).toNotEventually(equal(""))
                }
                
                it("too long max 30") {
                    vc.baseView?.eventHandler?.login(emailText: "a@a.com", passwordText: "1234567890123456789012345678901")
                    expect(vc.baseView?.getPasswordErrorText()).toNotEventually(equal(""))
                }
                
                describe("valid") {
                    it("6 characters") {
                        vc.baseView?.eventHandler?.login(emailText: "a@a.com", passwordText: "123456")
                        expect(vc.baseView?.getPasswordErrorText()).to(equal(""))
                    }
                    
                    it("30 characters") {
                        vc.baseView?.eventHandler?.login(emailText: "a@a.com", passwordText: "123456789012345678901234567890")
                        expect(vc.baseView?.getPasswordErrorText()).toEventually(equal(""))
                    }
                }
            }
        
            describe("account") {
                it("valid email and password") {
                    vc.baseView?.eventHandler?.login(emailText: "user@domain.com", passwordText: "123456")
                    expect(vc.isBeingPresented).to(equal(false))
                    expect(vc.baseView?.getEmailErrorText()).to(equal(""))
                }
            }

        }
    }
}
