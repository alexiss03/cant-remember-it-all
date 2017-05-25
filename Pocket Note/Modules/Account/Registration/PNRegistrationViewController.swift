//
//  PNRegistrationViewController.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

import SlideMenuControllerSwift
import RealmSwift
import PSOperations

class PNRegistrationViewController: UIViewController, PNNavigationBarProtocol, PNRegistrationViewDelegate {

    let baseView: PNRegistrationView? = {
        if let view = Bundle.main.loadNibNamed("PNRegistrationView", owner: self, options: nil)![0] as? PNRegistrationView {
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

        showNavigationBar(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: PNRegistrationViewDelegate Methods
    func signUpButtonTapped() {
        var isValidInput = true

        if baseView?.emailTextField.text == "" {
            baseView?.emailErrorLabel.text = "       You can't leave this empty"
            isValidInput = false
        } else if !validEmailFormat(string: baseView?.emailTextField.text) {
            baseView?.emailErrorLabel.text = "       Invalid email format"
            isValidInput = false
        } else {
            baseView?.emailErrorLabel.text = ""
        }

        if baseView?.passwordTextField.text == "" {
            baseView?.passwordErrorLabel.text = "       You can't leave this empty"
            isValidInput = false
        } else if let characters = baseView?.passwordTextField.text?.characters, characters.count < 6 {
            baseView?.passwordErrorLabel.text = "       Password too short (minimum of 6 characters)"
            isValidInput = false
        } else if let characters = baseView?.passwordTextField.text?.characters, characters.count > 30 {
            baseView?.passwordErrorLabel.text = "       Password too long (maximum of 30 characters)"
            isValidInput = false
        } else {
            baseView?.passwordErrorLabel.text = ""
        }

        if let username = baseView?.emailTextField.text, let password = baseView?.passwordTextField.text, isValidInput && !validateIfExisting() {

            let syncOperation = PNLoginUserOperation.init(username: username, password: password, nextViewController: self)
            RealmConstants.networkOperationQueue.addOperation(syncOperation)

        } else if validateIfExisting() {
            baseView?.emailErrorLabel.text = "       Account is already existing."
        }
    }

    func validEmailFormat(string: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: string)
        return result
    }

    func validateIfExisting() -> Bool {
        var realm: Realm?
        do {
            realm = try Realm()
        } catch { }

        guard let unwrappedRealm = realm else { return true }

        let account = Account()
        account.username = baseView?.emailTextField.text
        account.firstName = ""
        account.lastName = "This is a last name"
        account.password = baseView?.passwordTextField.text

        guard let username = baseView?.emailTextField.text else {
            return true
        }

        let existingAccount = unwrappedRealm.objects(Account.self).filter("username = '\(username)'").first
        return existingAccount != nil
    }

    func addAccountWith(username: String, password: String) {
        var realm: Realm?
        do {
            realm = try Realm()
        } catch { }

        guard let unwrappedRealm = realm else { return }

        let account = Account()
        account.username = username
        account.firstName = ""
        account.lastName = ""
        account.password = password

        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(account)
            }
        } catch { }
    }

}

extension PNRegistrationViewController: PNShowNotesFeedProtocol {
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

protocol PNShowNotesFeedProtocol {
    func showNotesFeed()
}
