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

protocol PNLoginUserVIPERInteractor: VIPERInteractor { }
/** 
 The operation responsible for the Login and Registration business logic of the App.
 */
class PNLoginUserInteractor: Procedure, InputProcedure, OutputProcedure, PNLoginUserVIPERInteractor {
    public static let name = "Login User"

    var input: Pending<(String, String)> = .pending
    var output: Pending<ProcedureResult<SyncUser>> = .pending
    /**
     This is where the operation execution happens. The user is either logged in or registered depending on the value of `isRegister`. If successful, this calls the `showNotesFeed` method of the `nextViewController` and also finishes the operation. Otherwise, the operation is finished with an error.
     */
    override func execute() {
        guard let (username, password) = input.value else {
            print("Input value is nil")
            return
        }
        
        let usernameCredentials = SyncCredentials.usernamePassword(username: username, password: password, register: false)

        SyncUser.logIn(with: usernameCredentials, server: PNSharedRealm.authenticationServerURL) { [weak self] user, error in
            guard let strongSelf = self else {
                print("Weak self is nil")
                return
            }
            
            if let user = user {
                print("Realm user   Logged In: \(user)")
                strongSelf.finish(withResult: .success(user))
                
            } else if let error = error {
                guard let strongSelf = self else {
                    print("Weak self is nil")
                    return
                }
                
                print("Realm error \(error)")
                strongSelf.cancel(withError: error)
            }
        }
    }
}

class PNLoginMigrateDataInteractor: Procedure, InputProcedure {
    /// A tuple (String, String) value that is the output of this interactor.
    var input: Pending<SyncUser> = .pending
    private let presentationContext: UIViewController
    
    init(presentationContext: UIViewController) {
        self.presentationContext = presentationContext
        super.init()
    }
    
    override func execute() {
        guard let user = input.value else {
            return
        }
        
        guard let localRealm = PNSharedRealm.realmInstance() else {
            print("Local realm is nil")
            return
        }
        
        let notebooks = localRealm.objects(Notebook.self)
        let notes = localRealm.objects(Note.self)
        
        if notebooks.count == 0, notes.count == 0 {
            _ = PNSharedRealm.configureRealm(user: user)
            finish()
            return
        }
        
        let alertController = UIAlertController.init(title: "", message: "Do you want to merge the existing notes into your account?", preferredStyle: .alert)
        let mergeAction = UIAlertAction.init(title: "Yes", style: .default, handler: { [weak self] (_) in
            guard let strongSelf = self else {
                print("Weak self is nil")
                return
            }
            
            strongSelf.migrateLocalDataToRemote(user: user)
            strongSelf.finish()
        })
        
        let disregardAction = UIAlertAction.init(title: "No", style: .cancel, handler: { [weak self] (_) in
            guard let strongSelf = self else {
                print("Weak self is nil")
                return
            }
            
            _ = PNSharedRealm.configureRealm(user: user)
            strongSelf.finish()
        })
        
        alertController.addAction(mergeAction)
        alertController.addAction(disregardAction)
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                print("Weak self is nil")
                return
            }

            strongSelf.presentationContext.present(alertController, animated: true, completion: nil)
        }
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
