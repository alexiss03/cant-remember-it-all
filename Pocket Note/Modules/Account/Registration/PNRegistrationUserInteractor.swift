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

protocol PNRegistrationUserVIPERInteractor: VIPERInteractor { }

class PNRegistrationUserInteractor: Procedure, InputProcedure, PNRegistrationUserVIPERInteractor {
    public static let name = "Login User"
    
    var input: Pending<(String, String)> = .pending
    
    /**
     This is the instance initialization method.
     
     */
    override init() {
        super.init()
    }

    override func execute() {
        guard let (username, password) = input.value else {
            return
        }
        
        let usernameCredentials = SyncCredentials.usernamePassword(username: username, password: password, register: true)
        
        SyncUser.logIn(with: usernameCredentials,
                       server: PNSharedRealm.authenticationServerURL) { [weak self] user, error in
            guard let strongSelf = self else {
                print("Weak self is nil")
                return
            }
                        
            if let user = user {
                strongSelf.migrateLocalDataToRemote(user: user)
                strongSelf.createAccount(username: username)
                strongSelf.finish()
            } else if let error = error {
                print("Realm error \(error)")
                strongSelf.cancel(withError: error)
            }
        }
    }
    
    private func createAccount(username: String) {
        let account = Account()
        account.username = username
        
        let remoteRealm = PNSharedRealm.realmInstance()
        do {
            try remoteRealm?.write {
                let account = Account()
                account.username = username
                remoteRealm?.add(account)
            }
        } catch { }
    }
    
    private func migrateLocalDataToRemote(user: SyncUser) {
        guard let localRealm = PNSharedRealm.realmInstance() else {
            print("Local realm is nil")
            return
        }
        
        guard let remoteRealm = PNSharedRealm.configureRealm(user: user) else {
            print("Remote realm is nil")
            return
        }
        
        let accounts = localRealm.objects(Account.self)
        let notebooks = localRealm.objects(Notebook.self)
        let notes = localRealm.objects(Note.self)
        
        do {
            remoteRealm.beginWrite()
            for account in accounts {
                remoteRealm.create(Account.self, value: account, update: true)
            }
            
            for notebook in notebooks {
                remoteRealm.create(Notebook.self, value: notebook, update: true)
            }
            
            for note in notes {
                remoteRealm.create(Note.self, value: note, update: true)
            }
            
            try remoteRealm.commitWrite()
        } catch { }
        
        print("Realm user   Logged In: \(user)")
    }
}
