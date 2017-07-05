//
//  PNRegistrationUserInteractor.swift
//  Memo
//
//  Created by Hanet on 7/5/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import ProcedureKit
import RealmSwift


class PNRegistrationUserInteractor: Procedure, InputProcedure, VIPERInteractor {
    public static let name = "Login User"
    
    internal var input: Pending<(String, String)> = .pending
    
    /**
     This is the instance initialization method.
     
     */
    override init() {
        super.init()
    }

    public override func execute() {
        guard let (username, password) = input.value else {
            return
        }
        
        let usernameCredentials = SyncCredentials.usernamePassword(username: username, password: password, register: true)
        
        weak var weakSelf = self
        SyncUser.logIn(with: usernameCredentials,
                       server: PNSharedRealm.authenticationServerURL) { user, error in
            if let user = user {
                _ = PNSharedRealm.configureRealm(user: user)
                
                print("Realm user   Logged In: \(user)")
                weakSelf?.finish()
            } else if let error = error {
                print("Realm error \(error)")
                weakSelf?.cancel(withError: error)
            }
        }
    }
}
