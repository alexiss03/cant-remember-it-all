//
//  PNLogoutUserOperation.swift
//  Memo
//
//  Created by Hanet on 5/31/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import PSOperations
import RealmSwift

/**
 The `PNLogoutUserOperation` class logouts the current logged in user from the `Realm` instance it is logged into.
 */
class PNLogoutUserOperation: PSOperation {
    /**
     This method logs out the current SyncUser and dimisses the dismissingContext, if any.
    */
    override func execute() {
        SyncUser.current?.logOut()
    }
}
