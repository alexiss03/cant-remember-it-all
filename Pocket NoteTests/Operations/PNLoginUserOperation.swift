//
//  PNSyncUserOperation.swift
//  Memo
//
//  Created by Hanet on 5/25/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import ProcedureKit
import PSOperations
import RealmSwift

/** 
 The operation responsible for the Login and Registration business logic of the App.
 */
class PNLoginUserInteractor: Procedure, InputProcedure, VIPERInteractor {
    public static let name = "Login User"

    internal var input: Pending<(String, String)> = .pending
    
    /**
     This is the instance initialization method.
     
    */
    override init() {
        super.init()
    }

    /**
     This is where the operation execution happens. The user is either logged in or registered depending on the value of `isRegister`. If successful, this calls the `showNotesFeed` method of the `nextViewController` and also finishes the operation. Otherwise, the operation is finished with an error.
     */
    public override func execute() {
        guard let (username, password) = input.value else {
            return
        }
        
        let usernameCredentials = SyncCredentials.usernamePassword(username: username, password: password, register: false)

        weak var weakSelf = self
        SyncUser.logIn(with: usernameCredentials,
           server: PNSharedRealm.authenticationServerURL) { user, error in
            if let user = user {
                _ = PNSharedRealm.configureRealm(user: user)

                print("Realm user Logged In: \(user)")
                weakSelf?.finish()
            } else if let error = error {
                print("Realm error \(error)")
                weakSelf?.cancel(withError: error)
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
