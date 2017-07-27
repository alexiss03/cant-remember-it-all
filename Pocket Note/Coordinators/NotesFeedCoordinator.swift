//
//  NotesFeedCoordinator.swift
//  Memo
//
//  Created by Hanet on 7/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

protocol NotesFeedCoordinatorDelegate: class {
    func notesFeedCoordinatorDidLogout(notesFeedCoordinator: NotesFeedCoordinator)
}

class NotesFeedCoordinator: RootViewCoordinator {
    let services: Services
    var childCoordinators: [Coordinator] = []
    weak var delegate: NotesFeedCoordinatorDelegate?
    
    var rootViewController: UIViewController {
        let navigationController = UINavigationController()
        let notesFeedViewController = PNNotesFeedViewController()
        navigationController.setViewControllers([notesFeedViewController], animated: true)
        
        let sideMenuViewController = PNSideMenuViewController.init()
        sideMenuViewController.delegate = self
        
        let slideMenuController = SlideMenuController(mainViewController: navigationController, leftMenuViewController: sideMenuViewController)
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.hideStatusBar = false
        SlideMenuOptions.contentViewDrag = true

        return slideMenuController
    }
    
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    init(with services: Services) {
        self.services = services
    }
    
    func start() { }
}

extension NotesFeedCoordinator: PNSideMenuViewControllerDelegate {
    func didTapLogout() {
        delegate?.notesFeedCoordinatorDidLogout(notesFeedCoordinator: self)
    }
}
