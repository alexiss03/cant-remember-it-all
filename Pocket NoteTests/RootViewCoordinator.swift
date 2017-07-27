//
//  RootViewCoordinator.swift
//  Memo
//
//  Created by Hanet on 7/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Foundation
import UIKit

protocol RootViewControllerProvider: class {
    var rootViewController: UIViewController { get }
}

typealias RootViewCoordinator = Coordinator & RootViewControllerProvider
