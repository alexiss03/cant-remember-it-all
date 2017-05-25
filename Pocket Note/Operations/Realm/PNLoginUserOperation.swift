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
    
    var username: String
    var password: String
    var nextViewController: PNShowNotesFeedProtocol

    init(username: String, password: String, nextViewController: PNShowNotesFeedProtocol) {
        self.username = username
        self.password = password
        self.nextViewController = nextViewController
    }

    override func execute() {
        let usernameCredentials = SyncCredentials.usernamePassword(username: username, password: password)

        SyncUser.logIn(with: usernameCredentials,
           server: RealmConstants.serverURL) { user, error in
            if let user = user {
                DispatchQueue.main.async {
                    self.nextViewController.showNotesFeed()
                }
                print("Realm user Logged In: \(user)")
            } else if let error = error {
                print("Realm error \(error)")
            }
        }
    }
}
