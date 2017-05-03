//
//  PNRegistrationViewController.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class PNRegistrationViewController: UIViewController, PNNavigationBarProtocol, PNRegistrationViewDelegate {

    let baseView: PNRegistrationView? = {
        if let view = Bundle.main.loadNibNamed("PNRegistrationView", owner: self, options: nil)![0] as? PNRegistrationView {
            return view
        }
        return nil
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedBaseView = self.baseView {
            unwrappedBaseView.frame = self.view.frame
            self.view = unwrappedBaseView
            
            unwrappedBaseView.delegate = self
        }
        
        showNavigationBar(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: PNRegistrationViewDelegate Methods
    func signUpButtonTapped() {
        showNotesFeed()
    }
    
}

extension PNRegistrationViewController {
    func showNotesFeed() {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let unwrappedMainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationController") as? UINavigationController else {
            print("Notes Feed View Controller is nil")
            return
        }
        
        guard let unwrappedSideMenuViewController = mainStoryboard.instantiateViewController(withIdentifier: "PNSideMenuViewController") as? PNSideMenuViewController else {
            print("Side Menu View Controller is nil")
            return
        }
        
        let slideMenuController = SlideMenuController(mainViewController:unwrappedMainViewController, leftMenuViewController: unwrappedSideMenuViewController)
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.hideStatusBar = false
        SlideMenuOptions.contentViewDrag = true
        
        present(slideMenuController, animated: true, completion: nil)
    }
}

