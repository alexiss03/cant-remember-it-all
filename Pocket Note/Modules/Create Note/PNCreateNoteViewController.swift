//
//  PNCreateNoteViewController.swift
//  Pocket Note
//
//  Created by Mary Alexis Solis on 3/30/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import RealmSwift

protocol NoteContainer {
    var note: Note? {get set}
}

protocol NotebookContainer {
    var notebook: Notebook? {get set}
}

/**
 The class `PNCreateNoteViewController` is the custom view controller of the Create Note and Update Note modules
 */
class PNCreateNoteViewController: UIViewController, NoteContainer, NotebookContainer {
   
    /// A `PNCreateNoteView` that is the superview of a `PNCreateNoteViewController`.
    private let baseView: PNCreateNoteView? = {
        if let view = Bundle.main.loadNibNamed("PNCreateNoteView", owner: self, options: nil)![0] as? PNCreateNoteView {
            return view
        }
        return nil
    }()
    
    /// A `Note` instance that is to be updated. If this is nil, the a new note instance is to be created instead.
    var note: Note?
    /// A `Notebook` instance that will contain the note to be created or already contains the note to be updated.
    var notebook: Notebook?
    /// A `PNCreateNoteInteractor` instance that creates the new `Note` instance and stores it to the current `Realm`.
    var createNoteInteractor: PNCreateNoteInteractor?
    
    /**
     Overrides the superclass' implementation.
     
     Additionally, this method sets the baseView of this view controller and also calls the interactors initialization method.
     */
    internal  override func viewDidLoad() {
        super.viewDidLoad()

        if let unwrappedBaseView = baseView {
            unwrappedBaseView.frame = view.frame
            view = unwrappedBaseView
        }
        
        initInteractors()
    }
    
    /**
     Overrides the superclass' implementation.
     
     Additionally, this method sets the content of the baseView.
     */
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baseView?.setContent(note: note)
    }
    
    /**
     Overrides the superclass' implementation.
     
     Additionally, this sets the contentTextView to be the first responder of the baseView.
     
     - Parameter animated: A `Boolean` value indicating if the view  is to be animated after it appeared.
     */
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if note == nil {
            baseView?.contentTextView.becomeFirstResponder()
        }
    }
    
    /**
     Overrides the superclass' implementation.
     
     Additionally, this method triggers the updating of the note or creating a new note instance.
     */
    internal override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let contentTextView = baseView?.contentTextView.text else {
            print("Contet text view is nil")
            return
        }
        
        createNoteInteractor?.createNote(content: contentTextView, note: note, notebook: notebook)
    }
    
    /**
     Initializes a `PNCreateNoteInteractor` instance.
     */
    private func initInteractors() {
        guard let unwrappedRealm = PNSharedRealm.configureDefaultRealm() else { return }
        
        createNoteInteractor = PNCreateNoteInteractor.init(realm: unwrappedRealm)
    }
}
