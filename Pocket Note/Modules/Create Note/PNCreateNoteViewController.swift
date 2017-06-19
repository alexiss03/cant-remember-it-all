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
    var createNoteInteractor: PNCreateNoteInteractor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let unwrappedBaseView = baseView {
            unwrappedBaseView.frame = view.frame
            view = unwrappedBaseView
        }
        
        initInteractors()
    }
    
    private func initInteractors() {
        guard let unwrappedRealm = PNSharedRealm.configureDefaultRealm() else { return }
        
        createNoteInteractor = PNCreateNoteInteractor.init(note: note, notebook: notebook, realm: unwrappedRealm)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baseView?.setContent(note: note)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if note == nil {
            baseView?.contentTextView.becomeFirstResponder()
        }
    }

    internal override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    internal override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        createNoteInteractor?.createNote(content: baseView?.contentTextView.text)
    }
}
