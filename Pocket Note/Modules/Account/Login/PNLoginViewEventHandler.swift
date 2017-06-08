//
//  PNLoginViewEventHandler.swift
//  Memo
//
//  Created by Hanet on 6/7/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

/**
 This is a protocol that handles event for the Login module.
 */
protocol PNLoginViewEventHandler {
    func handleLogin(username: String, password: String)
}
