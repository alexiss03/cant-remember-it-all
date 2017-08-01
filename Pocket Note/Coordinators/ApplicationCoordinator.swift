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

class ApplicationCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    let window: UIWindow
    let services: Services
    
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    fileprivate lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        return navigationController
    }()
    
    init(window: UIWindow, services: Services) {
        self.window = window
        self.services = services
        
        self.childCoordinators = []
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        
        showNotesFeedViewController()
    }
    
    fileprivate func presentLoginViewController() {
        let loginViewController = PNLoginViewController()
        loginViewController.delegate = self
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                print("Weak self is nil")
                return
            }

            strongSelf.navigationController.setViewControllers([loginViewController], animated: true)
        }
    }
    
    fileprivate func rootAsLoginViewController() {
        let loginViewController = PNLoginViewController()
        loginViewController.delegate = self
        
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {
                print("Weak self is nil")
                return
            }
            
            strongSelf.navigationController.setViewControllers([loginViewController], animated: true)
        }
    }
    
    fileprivate func showNotesFeedViewController() {
        let notesFeedCoordinator = NotesFeedCoordinator.init(with: services, navigationController: navigationController)
        notesFeedCoordinator.delegate = self
        notesFeedCoordinator.start()
        addChildCoordinator(notesFeedCoordinator)
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                print("Weak self is nil")
                return
            }
            
            strongSelf.navigationController.setViewControllers([notesFeedCoordinator.rootViewController], animated: true)
        }
    }
}

extension ApplicationCoordinator: PNLoginViewControllerDelegate {
    func didTapRegistration() {
        showRegistrationViewController()
    }
    
    func loginSuccessful() {
        navigationController.navigationBar.isHidden = true
        showNotesFeedViewController()
    }
    
    func loginDismiss() {
       showNotesFeedViewController() 
    }
    
    private func showRegistrationViewController() {
        let registrationViewController = PNRegistrationViewController()
        registrationViewController.delegate = self
        
        DispatchQueue.main.async {
            self.navigationController.pushViewController(registrationViewController, animated: true)
        }
    }
}

extension ApplicationCoordinator: PNRegistrationViewControllerDelegate {
    func successfulRegistration() {
        navigationController.navigationBar.isHidden = true
        showNotesFeedViewController()
    }
}

extension ApplicationCoordinator: NotesFeedCoordinatorDelegate {
    func notesFeedCoordinatorDidLogout(notesFeedCoordinator: NotesFeedCoordinator) {
        rootAsLoginViewController()
        removeChildCoordinator(notesFeedCoordinator)
    }
    
    func notesFeedCoordinatorDidShowIntegrateAccount(notesFeedCoordinator: NotesFeedCoordinator) {
        presentLoginViewController()
        removeChildCoordinator(notesFeedCoordinator)
    }
}
