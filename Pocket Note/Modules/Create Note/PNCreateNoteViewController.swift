//
//  PNCreateNoteViewController.swift
//  Pocket Note
//
//  Created by Hanet on 3/30/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

class PNCreateNoteViewController: UIViewController {

    let v: PNCreateNoteView = Bundle.main.loadNibNamed("PNCreateNoteView", owner: self, options: nil)![0] as! PNCreateNoteView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.v.frame = self.view.frame
        self.view = self.v
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
