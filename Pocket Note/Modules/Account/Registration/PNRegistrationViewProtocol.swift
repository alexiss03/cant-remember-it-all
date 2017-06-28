//
//  PNRegistrationViewProtocol.swift
//  Memo
//
//  Created by Hanet on 6/7/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit.UILabel

/**
 The `PNRegistrationViewProtocol` protocol for the `emailErrorLabel` and `passwordErrorLabel` elements.
 */
protocol PNRegistrationViewProtocol: class {
    var emailErrorLabel: UILabel! {get set}
    var passwordErrorLabel: UILabel! {get set}
}
