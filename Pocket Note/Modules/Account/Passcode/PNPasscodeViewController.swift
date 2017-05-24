//
//  PNPasscodeViewController.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class PNPasscodeViewController: UIViewController, PNNavigationBarProtocol, PNPasscodeViewDelegate {

    let baseView: PNPasscodeView? = {
        if let view = Bundle.main.loadNibNamed("PNPasscodeView", owner: self, options: nil)![0] as? PNPasscodeView {
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
        // Dispose of any resources that can be recreated.
    }

    // MARK: PNPasscodeViewDelegate Methods
    func buttonTapped() {
        showInitialViewController()
    }

}

extension PNPasscodeViewController {
    func showInitialViewController () {
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
