//
//  NoteFeedMenu.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import UIKit

/**
 The `NoteFeedMenu` class inherits the `Menu` protocol but provides a a default method of setting the title of the navigation bar as a button.
 */
protocol NoteFeedMenu: Menu {
    func setNotebookButton(editNotebookInteractor: PNNotesEditNotebookInteractor?, currentNotebook: Notebook?, navigationItem: UINavigationItem) 
}

extension NoteFeedMenu {
    /**
     Sets the navigation title as the notebook name and the options for editing the notebook.
     - Parameter editNotebookInteractor: A  `PNNotesEditNotebookInteractor` instance for editing the notebook.
     - Parameter currentNotebook: A `Notebook` instance that is currently loaded to the user.
     - Parameter navigationItem: A `UINavigationItem` instance representing the navigation item of the current view controller.
     */
    func setNotebookButton(editNotebookInteractor: PNNotesEditNotebookInteractor?, currentNotebook: Notebook?, navigationItem: UINavigationItem) {
        if currentNotebook != nil {
            let notebookIcon  = UIImage(named: "IconOption")!.withRenderingMode(.alwaysOriginal)
            let notebookButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            notebookButton.setBackgroundImage(notebookIcon, for: .normal)
            
            let menuIconContainer = UIView(frame: notebookButton.frame)
            menuIconContainer.addSubview(notebookButton)
            
            let menuNotificationButtonItem = UIBarButtonItem(customView: menuIconContainer)
            navigationItem.rightBarButtonItem = menuNotificationButtonItem
            notebookButton.addTarget(editNotebookInteractor, action: #selector(PNNotesEditNotebookInteractor.showNotebookActions), for:.touchUpInside)
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
}
