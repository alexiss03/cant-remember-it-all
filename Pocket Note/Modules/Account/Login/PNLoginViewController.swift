//
//  PNLoginViewController.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import RealmSwift
import PSOperations
import ProcedureKit

protocol PNLoginVIPERRouter: VIPERRouter {
    func routeToNotesFeed()
    func showAlertController(_ alertController: UIAlertController)
    func routeToRegistration()
    func dismiss()
}

protocol PNLoginViewControllerDelegate: class {
    func didTapRegistration()
    func loginSuccessful()
    func loginDismiss()
}

/**
 The `PNLoginViewController` is the view controller for the Login module, and also the VIPER ROUTER for the Login module.
 */
class PNLoginViewController: UIViewController, PNNavigationBarProtocol, PNLoginVIPERRouter {
    /// This instance property is the superview of the current controller.
    var baseView: PNLoginView?
    private var eventHandler: PNLoginViewEventHandler?
    weak var delegate: PNLoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.baseView = view as? PNLoginView
        assembleEventHandlers()
        
        if let unwrappedBaseView = self.baseView {
            unwrappedBaseView.frame = self.view.frame
            self.view = unwrappedBaseView
        }
        
        baseView?.prepareForReuse()
    }
    
    private func assembleEventHandlers() {
        if let unwrappedBaseView = baseView {
            let loginEventHandler = PNLoginViewEventHandler.init(loginView: unwrappedBaseView, loginRouter: self, presentationContext: self)
            baseView?.eventHandler = loginEventHandler
        }
    }
    
    /** 
     This method overrides the superclass' implementation of `viewWillAppear()` set the navigation bar's visibility and resetting the `baseView` to reusing
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.leftBarButtonItem = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideNavigationBar(viewController: self)
    }
}

extension PNLoginViewController {
    /**
     This method directs this view controller to the event's feed page.
     */
    
    func routeToNotesFeed() {
        delegate?.loginSuccessful()
    }
    
    func routeAlertController(alert: UIAlertController) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                print("Weak self is nil")
                return
            }
            strongSelf.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertController(_ alertController: UIAlertController) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                print("Weak self is nil")
                return
            }
            strongSelf.present(alertController, animated: true, completion: nil)
        }
    }

    func routeToRegistration() {
        delegate?.didTapRegistration()
    }    
    
    func dismiss() {
        delegate?.loginDismiss()
    }
}
