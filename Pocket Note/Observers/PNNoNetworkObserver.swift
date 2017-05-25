//
//  PSNoNetworkObserver.swift
//  Memo
//
//  Created by Hanet on 5/25/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import PSOperations

struct PNNoNetworkObserver: OperationObserver {

    var presentationContext: UIViewController
    
    init(presentationContext: UIViewController) {
        self.presentationContext = presentationContext
    }
    
    func operationDidStart(_ operation: PSOperation) {
        
    }
    
    func operationDidCancel(_ operation: PSOperation) {
        let alertControlller = UIAlertController.init(title: "No Internet Connection", message: "Cannot proceed with this action. Please connect to  network to continue.", preferredStyle: .alert)
        let okButton = UIAlertAction.init(title: "Ok", style: .cancel) { (_) in
            alertControlller.dismiss(animated: true, completion: nil)
        }
        alertControlller.addAction(okButton)
        presentationContext.present(alertControlller, animated: true, completion: nil)
    }
    
    func operation(_ operation: PSOperation, didProduceOperation newOperation: Foundation.Operation) {
        
    }

    func operationDidFinish(_ operation: PSOperation, errors: [NSError]) {
        
    }
    
}
