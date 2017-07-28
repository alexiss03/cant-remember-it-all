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
    func routeToRegistration()
}

protocol PNLoginViewControllerDelegate: class {
    func didTapRegistration()
    func loginSuccessful()
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
    }
    
    private func assembleEventHandlers() {
        if let unwrappedBaseView = baseView {
            let loginEventHandler = PNLoginViewEventHandler.init(loginView: unwrappedBaseView, loginRouter: self)
            baseView?.eventHandler = loginEventHandler
        }
    }
    
    /** 
     This method overrides the superclass' implementation of `viewWillAppear()` set the navigation bar's visibility and resetting the `baseView` to reusing
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let unwrappedBaseView = self.baseView {
            unwrappedBaseView.frame = self.view.frame
            self.view = unwrappedBaseView
        }
        hideNavigationBar(viewController: self)
        baseView?.prepareForReuse()
    }
}

extension PNLoginViewController {
    /**
     This method directs this view controller to the event's feed page.
     */
    
    func routeToNotesFeed() {
        delegate?.loginSuccessful()
        dismiss(animated: true, completion: nil)
    }
    
    func routeAlertController(alert: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func routeToRegistration() {
        delegate?.didTapRegistration()
    }
}
