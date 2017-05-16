//
//  PNPasscodeView.swift
//  Pocket Note
//
//  Created by Hanet on 4/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

protocol PNPasscodeViewDelegate: class {
    func buttonTapped()
}

class PNPasscodeView: UIView {
    weak var delegate: PNPasscodeViewDelegate?
    
    @IBAction func buttonTapped(_ sender: Any) {
        delegate?.buttonTapped()
    }

}
