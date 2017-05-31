//
//  PNSyncUserOperation.swift
//  Memo
//
//  Created by Hanet on 5/25/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import PSOperations
import RealmSwift

class PNLoginUserOperation: PSOperation {
    public static let name = "Login User"
    
    private var username: String
    private var password: String
    private var nextViewController: PNShowNotesFeedProtocol
    private var isRegister: Bool

    public init(username: String, password: String, isRegister: Bool = false, nextViewController: PNShowNotesFeedProtocol) {
        self.username = username
        self.password = password
        self.nextViewController = nextViewController
        self.isRegister = isRegister
    }

    public override func execute() {
        let usernameCredentials = SyncCredentials.usernamePassword(username: username, password: password, register: isRegister)

        weak var weakSelf = self
        SyncUser.logIn(with: usernameCredentials,
           server: RealmConstants.serverURL) { user, error in
            if let user = user {
                DispatchQueue.main.async {
                    weakSelf?.nextViewController.showNotesFeed()
                }
                print("Realm user Logged In: \(user)")
                weakSelf?.finish()
            } else if let error = error {
                print("Realm error \(error)")
                weakSelf?.finishWithError(error as NSError)
            }
        }
    }
}

extension PNLoginUserOperation {
    static let realmError = NSError.init(domain: "error.login.register.realm", code: 1000, userInfo: nil)
}

extension PSOperation {
    override open func start() {
        for op in self.dependencies where op.isCancelled {
            cancel()
        }
        super.start()
    }
}
