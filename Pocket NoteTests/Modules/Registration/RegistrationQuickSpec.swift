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
        var vc: PNRegistrationViewController? = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "PNRegistrationViewController") as? PNRegistrationViewController
        var realm: Realm?

        beforeEach {
            vc = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "PNRegistrationViewController") as? PNRegistrationViewController
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
                    vc?.baseView?.delegate?.signUpButtonTapped()
                    expect(vc?.baseView?.emailErrorLabel.text).notTo(equal(""))
                }

                describe("invalid format") {
                    it("no @") {
                        vc?.baseView?.emailTextField.text = "aa"
                        vc?.baseView?.delegate?.signUpButtonTapped()
                        expect(vc?.baseView?.emailErrorLabel.text).notTo(equal(""))

                    }

                    it("no .") {
                        vc?.baseView?.emailTextField.text = "a@a"
                        vc?.baseView?.delegate?.signUpButtonTapped()
                        expect(vc?.baseView?.emailErrorLabel.text).notTo(equal(""))
                    }
                }

                it("valid format") {
                    vc?.baseView?.emailTextField.text = "a@a.com"
                    vc?.baseView?.delegate?.signUpButtonTapped()
                    expect(vc?.baseView?.emailErrorLabel.text).to(equal(""))
                }
            }

            describe("password input") {
                it("empty") {
                    vc?.baseView?.passwordTextField.text = ""
                    vc?.baseView?.delegate?.signUpButtonTapped()
                    expect(vc?.baseView?.passwordErrorLabel.text).notTo(equal(""))
                }

                it("too short min 6") {
                    vc?.baseView?.passwordTextField.text = "1234"
                    vc?.baseView?.delegate?.signUpButtonTapped()
                    expect(vc?.baseView?.passwordErrorLabel.text).notTo(equal(""))
                }

                it("too long max 30") {
                    vc?.baseView?.passwordTextField.text = "1234567890123456789012345678901"
                    vc?.baseView?.delegate?.signUpButtonTapped()
                    expect(vc?.baseView?.passwordErrorLabel.text).notTo(equal(""))
                }

                describe("valid") {
                    it("6 characters") {
                        vc?.baseView?.passwordTextField.text = "123456"
                        vc?.baseView?.delegate?.signUpButtonTapped()
                        expect(vc?.baseView?.passwordErrorLabel.text).to(equal(""))
                    }

                    it("30 characters") {
                        vc?.baseView?.passwordTextField.text = "123456789012345678901234567890"
                        vc?.baseView?.delegate?.signUpButtonTapped()
                        expect(vc?.baseView?.passwordErrorLabel.text).to(equal(""))
                    }
                }
            }

            describe("account") {
//                it("valid email and password") {
//                    guard let unwrappedRealm = realm else { return }
//
//                    let beforeSignUpAccountCount = unwrappedRealm.objects(Account.self).count
//
//                    vc?.baseView?.emailTextField.text = "user2@domain.com"
//                    vc?.baseView?.passwordTextField.text = "123456"
//                    vc?.baseView?.delegate?.signUpButtonTapped()
//
//                    let afterSignUpAccountCount = unwrappedRealm.objects(Account.self).count
//
//                    expect(afterSignUpAccountCount).to(equal(beforeSignUpAccountCount+1))
//                    expect(vc?.baseView?.emailErrorLabel.text).to(equal(""))
//
//                }

                it("existing account") {
                    guard let unwrappedRealm = realm else { return }

                    let beforeSignUpAccountCount = unwrappedRealm.objects(Account.self).count

                    vc?.baseView?.emailTextField.text = "user@domain.com"
                    vc?.baseView?.passwordTextField.text = "123456"
                    vc?.baseView?.delegate?.signUpButtonTapped()

                    let afterSignUpAccountCount = unwrappedRealm.objects(Account.self).count

                    expect(afterSignUpAccountCount).to(equal(beforeSignUpAccountCount))
                    //expect(vc?.baseView?.emailErrorLabel.text).notTo(equal(""))
                }
            }

            it("no internet connection") {
               
            }

            it("slow internet connection") {

            }

            describe("keyboard dismiss") {
                it("tap on view") {

                }

                it("tap on sign up") {

                }
            }
        }
    }
}
