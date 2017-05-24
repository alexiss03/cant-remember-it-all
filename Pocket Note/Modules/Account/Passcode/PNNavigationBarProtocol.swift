//
//  PNNavigationBarProtocol.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit.UIViewController

protocol PNNavigationBarProtocol {
    func hideNavigationBar(viewController: UIViewController)
    func showNavigationBar(viewController: UIViewController)
}

extension PNNavigationBarProtocol {
    func hideNavigationBar(viewController: UIViewController) {
        viewController.navigationController?.navigationBar.isHidden = true
    }

    func showNavigationBar(viewController: UIViewController) {
        viewController.navigationController?.navigationBar.isHidden = false
    }
}
