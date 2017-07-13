//
//  RegistrationQuickSpec.swift
//  Pocket Note
//
//  Created by Hanet on 5/9/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Quick
import Nimble

import UIKit
import RealmSwift

@testable import Memo

class RegistrationQuickSpec: QuickSpec {
    
    class MockPNRegistrationViewController: PNRegistrationViewController {
        override func viewDidLoad() {
            baseView = Bundle.main.loadNibNamed("PNRegistrationView", owner: self, options: nil)![0] as? PNRegistrationView
            super.viewDidLoad()
        }
    }
    
    override func spec() {
        var vc: MockPNRegistrationViewController? = MockPNRegistrationViewController()
        var realm: Realm?
        var baseView: PNRegistrationVIPERView?

        beforeEach {
            vc = MockPNRegistrationViewController()
            UIApplication.shared.keyWindow?.rootViewController = vc
            
            baseView = vc?.baseView
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
                    vc?.baseView?.eventHandler?.signUp(emailText: "", passwordText: "123456")
                    expect(baseView?.getEmailErrorText()).toNotEventually(equal(""))
                }

                describe("invalid format") {
                    it("no @") {
                        vc?.baseView?.eventHandler?.signUp(emailText: "aa", passwordText: "123456")
                        expect(baseView?.getEmailErrorText()).toEventually(equal(""))

                    }

                    it("no .") {
                        vc?.baseView?.eventHandler?.signUp(emailText: "a@a", passwordText: "123456")
                        expect(baseView?.getEmailErrorText()).toNotEventually(equal(""))
                    }
                }

                it("valid format") {
                    vc?.baseView?.eventHandler?.signUp(emailText: "a@a.com", passwordText: "123456")
                    expect(baseView?.getEmailErrorText()).toEventually(equal(""))
                }
            }

            describe("password input") {
                it("empty") {
                    vc?.baseView?.eventHandler?.signUp(emailText: "a@a.com", passwordText: "")
                    expect(baseView?.getPasswordErrorText()).toNotEventually(equal(""))
                }

                it("too short min 6") {
                    vc?.baseView?.eventHandler?.signUp(emailText: "a@a.com", passwordText: "1234")
                    expect(baseView?.getPasswordErrorText()).toNotEventually(equal(""))
                }

                it("too long max 30") {
                    vc?.baseView?.eventHandler?.signUp(emailText: "a@a.com", passwordText: "1234567890123456789012345678901")
                    expect(baseView?.getPasswordErrorText()).toNotEventually(equal(""))
                }

                describe("valid") {
                    it("6 characters") {
                        vc?.baseView?.eventHandler?.signUp(emailText: "a@a.com", passwordText: "123456")
                        expect(baseView?.getPasswordErrorText()).toEventually(equal(""))
                    }

                    it("30 characters") {
                        vc?.baseView?.eventHandler?.signUp(emailText: "a@a.com", passwordText: "123456789012345678901234567890")
                        expect(baseView?.getPasswordErrorText()).toEventually(equal(""))
                    }
                }
            }

            describe("account") {
                it("existing account") {
                    guard let unwrappedRealm = realm else { return }

                    let beforeSignUpAccountCount = unwrappedRealm.objects(Account.self).count
                    vc?.baseView?.eventHandler?.signUp(emailText: "user@domain.com", passwordText: "123456")

                    let afterSignUpAccountCount = unwrappedRealm.objects(Account.self).count
                    expect(afterSignUpAccountCount).toEventually(equal(beforeSignUpAccountCount))
                }
            }
        }
    }
}
