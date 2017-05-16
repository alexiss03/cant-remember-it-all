//
//  PNLoginViewController.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class PNLoginViewController: UIViewController, PNNavigationBarProtocol, PNLoginViewDelegate {

    let baseView: PNLoginView? = {
        if let view = Bundle.main.loadNibNamed("PNLoginView", owner: self, options: nil)![0] as? PNLoginView {
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
        
        hideNavigationBar(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func showRegistration() {
        self.performSegue(withIdentifier: "TO_REGISTRATION", sender: self)
    }
    
    // MARK: PNLoginViewDelegate Methods
    
    func loginButtonTapped() {
        showNotesFeed()
    }
    
    func signUpHereButtonTapped() {
        showRegistration()
    }
    
}

extension PNLoginViewController {
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
