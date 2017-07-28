//
//  PNRegistrationViewController.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

import SlideMenuControllerSwift
import RealmSwift
import PSOperations

protocol PNRegistrationVIPERRouter: VIPERRouter {
    func routeToNotesFeed()
}

protocol PNRegistrationViewControllerDelegate: class {
    func successfulRegistration()
}
/**
    The view controller class responsible for the Registration module.
 */
class PNRegistrationViewController: UIViewController, PNNavigationBarProtocol, PNRegistrationVIPERRouter {
    
    /// This is the main view of the registration page.
    var baseView: PNRegistrationView?
    
    /// This is the event handler for the Registration module.
    var registrationEventHandler: PNRegistrationEventHandler?

    /**
     This method overrides `viewDidLoad()` to initialize the `baseView` and set the navigation bar visibility.
     */
    
    weak var delegate: PNRegistrationViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView = view as? PNRegistrationView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let unwrappedBaseView = self.baseView {
            unwrappedBaseView.frame = self.view.frame
            self.view = unwrappedBaseView
        }
        showNavigationBar(viewController: self)
        initEventHandlers()
    }
    
    private func initEventHandlers() {
        if let unwrappedBaseView = baseView {
            registrationEventHandler = PNRegistrationEventHandler.init(registrationView: unwrappedBaseView, registrationRouter: self)
            baseView?.eventHandler = registrationEventHandler
        }
    }
    
    /**
        This method checks if an input string is in the form of a valid email address.
     
        - Parameter string: Input string to be checked for email format.
     */
    func validEmailFormat(string: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: string)
        return result
    }
}

extension PNRegistrationViewController {
    final func routeToNotesFeed() {
        delegate?.successfulRegistration()
    }
    
    final func routeAlertController(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}
