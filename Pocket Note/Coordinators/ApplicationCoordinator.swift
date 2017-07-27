//
//  ApplicationCoordinator.swift
//  Memo
//
//  Created by Hanet on 7/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift
import SlideMenuControllerSwift

public struct Services {
    
}

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func addChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0 !== childCoordinator })
    }
}

public class ApplicationCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    let window: UIWindow
    let services: Services
    
    public var rootViewController: UIViewController {
        return self.navigationController
    }
    
    fileprivate lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()
    
    public init(window: UIWindow, services: Services) {
        self.window = window
        self.services = services
        
        self.childCoordinators = []
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
    }
    
    public func start() {
        if !SyncUser.all.isEmpty {
            showNotesFeedViewController()
        } else {
            showLoginViewController()
        }
    }
    
    fileprivate func showLoginViewController() {
        let loginViewController = PNLoginViewController()
        loginViewController.delegate = self
        navigationController.setViewControllers([loginViewController], animated: true)
    }
    
    private func showNotesFeedViewController() {
        let notesFeedCoordinator = NotesFeedCoordinator.init(with: services)
        notesFeedCoordinator.delegate = self
        notesFeedCoordinator.start()
        addChildCoordinator(notesFeedCoordinator)
        self.navigationController.setViewControllers([notesFeedCoordinator.rootViewController], animated: true)
    }
}

extension ApplicationCoordinator: PNLoginViewControllerDelegate {
    func didTapRegistration() {
        showRegistrationViewController()
    }
    
    private func showRegistrationViewController() {
        let registrationViewController = PNRegistrationViewController()
        navigationController.pushViewController(registrationViewController, animated: true)
    }
}

extension ApplicationCoordinator: NotesFeedCoordinatorDelegate {
    func notesFeedCoordinatorDidLogout(notesFeedCoordinator: NotesFeedCoordinator) {
        showLoginViewController()
        removeChildCoordinator(notesFeedCoordinator)
    }
}
