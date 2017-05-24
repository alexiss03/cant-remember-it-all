//
//  ViewController+Extension.swift
//  Pocket Note
//
//  Created by Hanet on 5/23/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

extension UIViewController {
    func loadViewProgrammatically() {
        self.beginAppearanceTransition(true, animated: false)
        self.endAppearanceTransition()
    }
}
