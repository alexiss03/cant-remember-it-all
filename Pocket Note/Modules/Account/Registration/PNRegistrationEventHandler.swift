//
//
//  PNRegistrationEventHandler.swift
//  Memo
//
//  Created by Hanet on 6/7/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

/**
 The `PNRegistrationEventHandler` protocol contains event handler's for the Registratiosn module.
 */
protocol PNRegistrationEventHandler {
    func handleRegistration(username: String, password: String)
}
