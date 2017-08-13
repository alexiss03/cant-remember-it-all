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
class PNCreateNoteViewController: UIViewController, PNNavigationBarProtocol {
    /// A `PNCreateNoteView` that is the superview of a `PNCreateNoteViewController`.
    var baseView: PNCreateNoteView?
    
    /// A `Note` instance that is to be updated. If this is nil, the a new note instance is to be created instead.
     var note: Note?
    /// A `Notebook` instance that will contain the note to be created or already contains the note to be updated.
    var notebook: Notebook?
    private var eventHandler: PNCreateNoteVIPEREventHandler?
    
    /**
     Overrides the superclass' implementation.
     
     Additionally, this method sets the baseView of this view controller and also calls the interactors initialization method.
     */
     override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView = view as? PNCreateNoteView
        initEventHandlers()
        baseView?.contentTextView.delegate = self
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let unwrappedBaseView = baseView, let contentText = note?.body {
            unwrappedBaseView.setContentTextView(content: contentText)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let unwrappedBaseView = baseView, note == nil {
            unwrappedBaseView.setContentTextViewAsFirstResponder()
        }
    }
    
    /**
     Overrides the superclass' implementation.
     
     Additionally, this method triggers the updating of the note or creating a new note instance.
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.saveNote(content: baseView?.getContentText())
    }
}

extension PNCreateNoteViewController: VIPERRouter {
    func routeAlertController(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

extension PNCreateNoteViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.attributedText = NSAttributedString.init(string: textView.text + text, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize:PNNoteTypographyContants.normalFontSize)])
        
        return false
    }
}
