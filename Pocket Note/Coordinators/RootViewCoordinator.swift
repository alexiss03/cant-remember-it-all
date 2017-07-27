//
//  RootViewCoordinator.swift
//  Memo
//
//  Created by Hanet on 7/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import Foundation
import UIKit

public protocol RootViewControllerProvider: class {
    // The coordinators 'rootViewController'. It helps to think of this as the view
    // controller that can be used to dismiss the coordinator from the view hierarchy.
    var rootViewController: UIViewController { get }
}

/// A Coordinator type that provides a root UIViewController
public typealias RootViewCoordinator = Coordinator & RootViewControllerProvider
