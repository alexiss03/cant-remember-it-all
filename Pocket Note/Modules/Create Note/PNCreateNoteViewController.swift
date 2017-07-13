//
//  PNCreateNoteViewController.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/30/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift
import ProcedureKit

protocol PNCreateNoteRouter: VIPERRouter { }

/** 
 The class `PNCreateNoteViewController` is the custom view controller of the Create Note and Update Note modules
 */
class PNCreateNoteViewController: UIViewController {
    /// A `PNCreateNoteView` that is the superview of a `PNCreateNoteViewController`.
    internal var baseView: PNCreateNoteView? {
        get {
            return view as? PNCreateNoteView
        }
    }
    
    /// A `Note` instance that is to be updated. If this is nil, the a new note instance is to be created instead.
    internal  var note: Note?
    /// A `Notebook` instance that will contain the note to be created or already contains the note to be updated.
    internal var notebook: Notebook?
    /// A `PNCreateNoteInteractor` instance that creates the new `Note` instance and stores it to the current `Realm`.
    private var createNoteInteractor: PNCreateNoteInteractor?
    private var eventHandler: PNCreateNoteVIPEREventHandler?
    
    /**
     Overrides the superclass' implementation.
     
     Additionally, this method sets the baseView of this view controller and also calls the interactors initialization method.
     */
    internal  override func viewDidLoad() {
        super.viewDidLoad()
        
        initEventHandlers()
    }
    
    private func initEventHandlers() {
        if let unwrappedRealm = PNSharedRealm.configureDefaultRealm() {
            eventHandler = PNCreateNoteEventHandler.init(note: note, notebook: notebook, realm: unwrappedRealm)
        }
    }
    
    /**
     Overrides the superclass' implementation.
     
     Additionally, this method sets the content of the baseView.
     */
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let unwrappedBaseView = baseView, let contentText = note?.body {
            unwrappedBaseView.setContentTextView(content: contentText)
        }
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let unwrappedBaseView = baseView, note == nil {
            unwrappedBaseView.setContentTextViewAsFirstResponder()
        }
    }
    
    /**
     Overrides the superclass' implementation.
     
     Additionally, this method triggers the updating of the note or creating a new note instance.
     */
    internal override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.saveNote(content: baseView?.getContentText())
    }
}

extension PNCreateNoteViewController: VIPERRouter {
    func routeAlertController(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}
