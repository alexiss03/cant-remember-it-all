//
//  PNLoginViewProtocol.swift
//  Memo
//
//  Created by Hanet on 6/7/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit.UILabel

/**
 This class is a protocol of the `PNLoginView`'s `emailErrorLabel` and `passwordErrorLabel`.
 */
protocol PNLoginViewProtocol: class {
    var emailErrorLabel: UILabel! {get set}
    var passwordErrorLabel: UILabel! {get set}
}
