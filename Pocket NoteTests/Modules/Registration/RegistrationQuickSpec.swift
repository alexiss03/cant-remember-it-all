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
    override func spec() {
        var vc: PNRegistrationViewController? = PNRegistrationViewController()
        var realm: Realm?

        beforeEach {
            vc = PNRegistrationViewController()
            UIApplication.shared.keyWindow?.rootViewController = vc
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
                    expect(vc?.baseView?.emailErrorLabel.text).toEventually(equal(""))
                }

                describe("invalid format") {
                    it("no @") {
                        vc?.baseView?.eventHandler?.signUp(emailText: "aa", passwordText: "123456")
                        expect(vc?.baseView?.emailErrorLabel.text).toEventually(equal(""))

                    }

                    it("no .") {
                        vc?.baseView?.eventHandler?.signUp(emailText: "a@a", passwordText: "123456")
                        expect(vc?.baseView?.emailErrorLabel.text).toNotEventually(equal(""))
                    }
                }

                it("valid format") {
                    vc?.baseView?.eventHandler?.signUp(emailText: "a@a.com", passwordText: "123456")
                    expect(vc?.baseView?.emailErrorLabel.text).toEventually(equal(""))
                }
            }

            describe("password input") {
                it("empty") {
                    vc?.baseView?.eventHandler?.signUp(emailText: "a@a.com", passwordText: "")
                    expect(vc?.baseView?.passwordErrorLabel.text).toNotEventually(equal(""))
                }

                it("too short min 6") {
                    vc?.baseView?.eventHandler?.signUp(emailText: "a@a.com", passwordText: "1234")
                    expect(vc?.baseView?.passwordErrorLabel.text).toNotEventually(equal(""))
                }

                it("too long max 30") {
                    vc?.baseView?.eventHandler?.signUp(emailText: "a@a.com", passwordText: "1234567890123456789012345678901")
                    expect(vc?.baseView?.passwordErrorLabel.text).toNotEventually(equal(""))
                }

                describe("valid") {
                    it("6 characters") {
                        vc?.baseView?.eventHandler?.signUp(emailText: "a@a.com", passwordText: "123456")
                        expect(vc?.baseView?.passwordErrorLabel.text).toEventually(equal(""))
                    }

                    it("30 characters") {
                        vc?.baseView?.eventHandler?.signUp(emailText: "a@a.com", passwordText: "123456789012345678901234567890")
                        expect(vc?.baseView?.passwordErrorLabel.text).toEventually(equal(""))
                    }
                }
            }

            describe("account") {
                it("existing account") {
                    guard let unwrappedRealm = realm else { return }

                    let beforeSignUpAccountCount = unwrappedRealm.objects(Account.self).count

                    vc?.baseView?.emailTextField.text = "user@domain.com"
                    vc?.baseView?.passwordTextField.text = "123456"
                    vc?.baseView?.eventHandler?.signUp(emailText: "user@domain.com", passwordText: "123456")

                    let afterSignUpAccountCount = unwrappedRealm.objects(Account.self).count

                    expect(afterSignUpAccountCount).toEventually(equal(beforeSignUpAccountCount))
                }
            }
        }
    }
}
