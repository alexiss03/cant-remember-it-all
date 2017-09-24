//
//  Menu.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import UIKit
import SlideMenuControllerSwift
/**
 The `Menu` protocol contains the default implementation of setting the title button of the navigation.
 */
protocol Menu {
    func setMenu(title: String, target: Any?, action: Selector, viewController: UIViewController, slideController: UIViewController) 
}

extension Menu {
    func setMenu(title: String, target: Any?, action: Selector, viewController: UIViewController, slideController: UIViewController) {
        let navigationItem = viewController.navigationItem
        let navigationBar = viewController.navigationController?.navigationBar
        
        let pocketNoteButton = UIButton.init(type: .custom)
        let attributedTitle = NSAttributedString.init(string: title, attributes: [NSFontAttributeName: UIFont(name: "Lato-Italic", size: 20.0)!, NSForegroundColorAttributeName: UIColor.black])
        pocketNoteButton.setAttributedTitle(attributedTitle, for: .normal)
        pocketNoteButton.addTarget(target, action: action, for: .touchUpInside)
        navigationItem.titleView = pocketNoteButton
        navigationBar?.backgroundColor = UIColor.white
        navigationBar?.isTranslucent = false
        
        let menuIcon  = UIImage(named: "IconMenu")!.withRenderingMode(.alwaysOriginal)
        let menuButton = UIButton(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        menuButton.setBackgroundImage(menuIcon, for: .normal)
        menuButton.addTarget(slideController, action: #selector(SlideMenuController.openLeft), for: .touchUpInside)
        
        let menuIconContainer = UIView(frame: menuButton.frame)
        menuIconContainer.addSubview(menuButton)
        
        let menuNotificationButtonItem = UIBarButtonItem(customView: menuIconContainer)
        navigationItem.leftBarButtonItem = menuNotificationButtonItem
        
    }
}
