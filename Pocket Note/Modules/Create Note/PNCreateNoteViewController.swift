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
    
    var note: Note?
    var notebook: Notebook?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let unwrappedBaseView = baseView {
            unwrappedBaseView.frame = view.frame
            view = unwrappedBaseView
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baseView?.setContent(note: note)
    }

    internal override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let contentTextView = baseView?.contentTextView, contentTextView.text.characters.count > 0 else { return }
        guard let unwrappedRealm = PNSharedRealm.configureDefaultRealm() else { return }
        
        if let unwrappedNote = note {
            do {
                try unwrappedRealm.write {
                    if unwrappedNote.body != baseView?.contentTextView.text {
                        unwrappedNote.body = baseView?.contentTextView.text
                        unwrappedNote.dateUpdated = Date()
                    }
                }
            } catch { }
        } else {
            let note = Note()
            note.noteId = "\(Date().timeStampFromDate())"
            note.body = baseView?.contentTextView.text
            note.title = "This is a title."
            note.dateCreated = Date()
            note.dateUpdated = Date()
            note.notebook = notebook
            
            do {
                try unwrappedRealm.write {
                    unwrappedRealm.add(note)
                }
            } catch { }
        }
        
    }
}
