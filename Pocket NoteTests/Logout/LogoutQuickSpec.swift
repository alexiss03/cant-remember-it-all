//
//  LogoutQuickSpec.swift
//  Memo
//
//  Created by Hanet on 6/18/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Quick
import Nimble

import RealmSwift
import UIKit

import XCTest
import Foundation

@testable import Memo

class LogoutQuickSpec: QuickSpec {
    
    override func spec() {
        var vc: PNSideMenuViewController? = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PNSideMenuViewController") as? PNSideMenuViewController
        var realm: Realm?
        
        beforeEach {
            vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PNSideMenuViewController") as? PNSideMenuViewController
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
        
        describe("logout") {
            it("successful") {
                guard let unwrappedVC = vc else {
                    print("View Controller is nil")
                    return
                }
                
                let viewController = UIViewController.init()
                
                UIApplication.shared.keyWindow?.rootViewController = viewController
                viewController.present(unwrappedVC, animated: true, completion: nil)
                
                unwrappedVC.logoutButtonTapped()
                expect(unwrappedVC.presentingViewController).toEventually(beNil(), timeout: 10)
            }
            
            it("not successful") {
                guard let unwrappedVC = vc else {
                    print("View Controller is nil")
                    return
                }
                
                let viewController = UIViewController.init()
                
                UIApplication.shared.keyWindow?.rootViewController = viewController
                viewController.present(unwrappedVC, animated: true, completion: nil)
            
                expect(unwrappedVC.presentingViewController).toEventuallyNot(beNil(), timeout: 10)
            }
        }
    }
}
