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

class NotesFeedCoordinatorPayload {
    var currentNotebook: Notebook?
}

class NotesFeedCoordinator: RootViewCoordinator {
    let services: Services
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: NotesFeedCoordinatorDelegate?
    
    var notesFeedPayload: NotesFeedCoordinatorPayload?
    
    var rootViewController: UIViewController {
        if let slideMenuController = slideMenuController {
            return slideMenuController
        }
        return self.navigationController
    }
    
    lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        return navigationController
    }()
    
    var notesFeedNavigationController: UINavigationController?
    var slideMenuController: SlideMenuController?
    
    init(with services: Services, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func start() {
        DispatchQueue.main.async {
            let notesFeedNavigationController = UINavigationController()
            let notesFeedViewController = PNNotesFeedViewController()
            notesFeedViewController.delegate = self
            
            self.notesFeedPayload = NotesFeedCoordinatorPayload.init()
            notesFeedViewController.update(currentNotebook: self.notesFeedPayload?.currentNotebook)
           
            notesFeedNavigationController.setViewControllers([notesFeedViewController], animated: true)
            self.notesFeedNavigationController = notesFeedNavigationController
            
            let sideMenuViewController = PNSideMenuViewController.init()
            sideMenuViewController.delegate = self
            
            let slideMenuController = SlideMenuController(mainViewController: notesFeedNavigationController, leftMenuViewController: sideMenuViewController)
            SlideMenuOptions.contentViewScale = 1
            SlideMenuOptions.hideStatusBar = false
            SlideMenuOptions.contentViewDrag = true
            
            self.slideMenuController = slideMenuController
            self.navigationController.setViewControllers([slideMenuController], animated: true)
        }
    }
}

extension NotesFeedCoordinator: PNSideMenuViewControllerDelegate {
    func didTapLogout() {
        delegate?.notesFeedCoordinatorDidLogout(notesFeedCoordinator: self)
    }
    
    func didTapNotebooksList() {
        let notebooksListViewController = PNNotebooksListViewController()
        notebooksListViewController.delegate = self
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf =  self else {
                print("Self is nil")
                return
            }

            strongSelf.notesFeedNavigationController?.present(notebooksListViewController, animated: true, completion: nil)
        }
    }
    
    func didTapIntegrateAccount() {
        showLoginViewController()
    }
    
    fileprivate func showLoginViewController() {
        let loginViewController = PNLoginViewController()
        loginViewController.delegate = self
        
        DispatchQueue.main.async {[unowned self] in
            self.navigationController.navigationBar.isHidden = false
            self.navigationController.navigationBar.tintColor = .black
            self.navigationController.pushViewController(loginViewController, animated: true)
        }
    }
}

extension NotesFeedCoordinator: PNLoginViewControllerDelegate {
    func didTapRegistration() {
        let registrationViewController = PNRegistrationViewController()
        registrationViewController.delegate = self
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf =  self else {
                print("Self is nil")
                return
            }
            strongSelf.navigationController.pushViewController(registrationViewController, animated: true)
        }
    }
    
    func loginSuccessful() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                print("Self is nil")
                return
            }
            strongSelf.navigationController.popToRootViewController(animated: true)
            strongSelf.start()
        }
    }
    
    func loginDismiss() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                print("Self is nil")
                return
            }
            
            strongSelf.navigationController.popToRootViewController(animated: true)
        }
    }
}

extension NotesFeedCoordinator: PNRegistrationViewControllerDelegate {
    func registrationSuccessful() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                print("Self is nil")
                return
            }
            
            strongSelf.navigationController.popViewController(animated: false)
            strongSelf.loginDismiss()
            strongSelf.start()
        }
    }
}

extension NotesFeedCoordinator: PNNotebooksListViewControllerDelegate {
    func update(currentNotebook: Notebook?) {
        notesFeedPayload?.currentNotebook = currentNotebook
        
        guard let notesFeedViewController = self.notesFeedNavigationController?.childViewControllers.first as? PNNotesFeedViewController  else {
            print("Notes feed is nil")
            return
        }
        
        notesFeedViewController.update(currentNotebook: notesFeedPayload?.currentNotebook)
    }
}

extension NotesFeedCoordinator: PNNotesFeedViewControllerDelegate {
    func didTapCreateNote(notebook: Notebook?) {
        notesFeedPayload?.currentNotebook = notebook
        
        let createNoteViewController = PNCreateNoteViewController()
        createNoteViewController.notebook = notesFeedPayload?.currentNotebook
        
        DispatchQueue.main.async {
            self.notesFeedNavigationController?.pushViewController(createNoteViewController, animated: true)
        }
    }
}
