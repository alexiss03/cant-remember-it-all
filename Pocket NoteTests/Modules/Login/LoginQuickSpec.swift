//
//  LoginQuickSpec.swift
//  Pocket Note
//
//  Created by Hanet on 5/8/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Quick
import Nimble

@testable import Pocket_Note

class LoginQuickSpec: QuickSpec {
    override func spec() {

        _ = PNLoginViewController()

        beforeEach {

        }

        describe("login via email") {
            describe("wrong username") {
                it("empty email") {
                }
            }

            describe("wrong password") {
                it("empty password") {

                }

                it("too short") {

                }

                it("too long") {

                }

                it("wrong combination") {

                }
            }

            it("right input") {

            }

            it("no internet connection") {

            }

            it("slow internet connection") {

            }
        }

    }

}
