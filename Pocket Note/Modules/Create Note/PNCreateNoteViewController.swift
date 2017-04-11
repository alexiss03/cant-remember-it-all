//
//  PNCreateNoteViewController.swift
//  Pocket Note
//
//  Created by Hanet on 3/30/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

class PNCreateNoteViewController: UIViewController {

    let baseView: PNCreateNoteView? = {
        if let view = Bundle.main.loadNibNamed("PNCreateNoteView", owner: self, options: nil)![0] as? PNCreateNoteView {
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
        // Dispose of any resources that can be recreated.
    }
}
