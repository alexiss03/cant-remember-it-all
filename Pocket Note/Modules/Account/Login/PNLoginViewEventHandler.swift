//
//  PNLoginViewEventHandler.swift
//  Memo
//
//  Created by Hanet on 6/7/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

/**
 This class is a delegate of the actions performed on `PNLoginView`.
 */
protocol PNLoginViewVIPEREventHandler: class {
    func loginButtonTapped(emailText: String?, passwordText: String?)
    func signUpHereButtonTapped()
}
