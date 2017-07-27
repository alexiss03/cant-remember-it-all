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
    
    final func routeToNotesFeed() {
        DispatchQueue.main.async {
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            guard let unwrappedMainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationController") as? UINavigationController else {
                print("Notes Feed View Controller is nil")
                return
            }
            
            let sideMenuViewController = PNSideMenuViewController.init()
            
            let slideMenuController = SlideMenuController(mainViewController: unwrappedMainViewController, leftMenuViewController: sideMenuViewController)
            SlideMenuOptions.contentViewScale = 1
            SlideMenuOptions.hideStatusBar = false
            SlideMenuOptions.contentViewDrag = true
            
            self.present(slideMenuController, animated: true, completion: nil)
        }
    }
    
    final func routeAlertController(alert: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    /**
     This method calls a perform segue to the Registration page.
     */
    final func routeToRegistration() {
        delegate?.didTapRegistration()
    }
}
