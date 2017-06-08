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

/** 
 The operation responsible for the Login and Registration business logic of the App.
 */
class PNLoginUserOperation: PSOperation {
    public static let name = "Login User"
    
    // The username of the User to be logged in or registered
    private var username: String
    
    // The password of the User to be logged in or registered
    private var password: String
    
    // The view controller to be presented when the logged in or registered in succesful
    private var nextViewController: PNShowNotesFeedProtocol
    
    // Identifies if the operation is for log in or register
    private var isRegister: Bool

    /**
     This is the instance initialization method.
     
     - Parameter username: This is the username for login or register
     - Parameter password: This is the password for login or register
     - Parameter isRegister: Boolean value if the operation is to be used for registration. The default value is `false`
     - Parameter nextViewController: This is the object that conforms to `PNShowNotesFeedProtocol` that redirects to a new view controller if the login or register is successful
     
    */
    public required init(username: String, password: String, isRegister: Bool = false, nextViewController: PNShowNotesFeedProtocol) {
        self.username = username
        self.password = password
        self.nextViewController = nextViewController
        self.isRegister = isRegister
    }

    /**
     This is where the operation execution happens. The user is either logged in or registered depending on the value of `isRegister`. If successful, this calls the `showNotesFeed` method of the `nextViewController` and also finishes the operation. Otherwise, the operation is finished with an error.
     */
    public override func execute() {
        let usernameCredentials = SyncCredentials.usernamePassword(username: username, password: password, register: isRegister)

        weak var weakSelf = self
        SyncUser.logIn(with: usernameCredentials,
           server: PNSharedRealm.authenticationServerURL) { user, error in
            if let user = user {
                _ = PNSharedRealm.configureRealm(user: user)
                
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

extension PSOperation {
    /**
     This is an important extension method to `PSOperation`. This cancels the current operation if at least one of its dependencies was cancelled.
     */
    override open func start() {
        for op in self.dependencies where op.isCancelled {
            cancel()
        }
        super.start()
    }
}
