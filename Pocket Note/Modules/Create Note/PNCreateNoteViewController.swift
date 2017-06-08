//
//  PNCreateNoteViewController.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/30/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

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

    internal override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let unwrappedRealm = PNSharedRealm.configureDefaultRealm() else { return }
        
        let note = Note()
        note.noteId = "\(Date().timeStampFromDate())"
        note.body = baseView?.contentTextView.text
        note.title = "This is a title."
        note.dateCreated = Date()
        
        do {
            try unwrappedRealm.write {
                unwrappedRealm.add(note)
            }
        } catch { }

    }
}
