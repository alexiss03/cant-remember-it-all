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
    /// The view controller to be dismissed
    weak var dismissingContext: UIViewController?
    
    /**
     This method is for the initialization of the class PNLogoutUserOperation.
     
     - Parameter dismissingContext: The view controller that needs to be dismissed when logging out.
     */
    public required init(dismissingContext: UIViewController?) {
        super.init()
        self.dismissingContext = dismissingContext
    }
    
    /**
     This method logs out the current SyncUser and dimisses the dismissingContext, if any.
    */
    override func execute() {
        SyncUser.current?.logOut()
        
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.dismissingContext?.dismiss(animated: true, completion: nil)
        }
    }
}
