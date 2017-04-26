//
//  PNSideMenuViewController.swift
//  Pocket Note
//
//  Created by Hanet on 4/26/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

class PNSideMenuViewController: UIViewController {

    let baseView: PNSideMenuView? = {
        if let view = Bundle.main.loadNibNamed("PNSideMenuView", owner: self, options: nil)![0] as? PNSideMenuView {
            return view
        }
        return nil
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedBaseView = self.baseView {
            unwrappedBaseView.frame = self.view.frame
            self.view = unwrappedBaseView
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
