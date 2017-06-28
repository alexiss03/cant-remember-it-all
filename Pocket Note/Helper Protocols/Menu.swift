//
//  Menu.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import UIKit

/**
 The `Menu` protocol contains the default implementation of setting the title button of the navigation.
 */
protocol Menu {
    func setMenu(title: String, target: Any?, action: Selector, navigationItem: UINavigationItem, navigationBar: UINavigationBar?)
}

extension Menu {
    func setMenu(title: String, target: Any?, action: Selector, navigationItem: UINavigationItem, navigationBar: UINavigationBar?) {
        let pocketNoteButton = UIButton.init(type: .custom)
        let attributedTitle = NSAttributedString.init(string: title, attributes: [NSFontAttributeName: UIFont(name: "Lato-Italic", size: 20.0)!, NSForegroundColorAttributeName: UIColor.black])
        pocketNoteButton.setAttributedTitle(attributedTitle, for: .normal)
        pocketNoteButton.addTarget(target, action: action, for: .touchUpInside)
        navigationItem.titleView = pocketNoteButton
        navigationBar?.backgroundColor = UIColor.white
        navigationBar?.isTranslucent = false
    }
}
