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
import TesseractOCR

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
    var inputStyleMode: TextInputStyleMode = .normal
    
    fileprivate var createEventHandler: PNCreateNoteVIPEREventHandler?
    fileprivate var scanDocumentEventHandler: PNScanDocumentVIPEREventHandler?
    
    private let imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController.init()
        imagePickerController.sourceType = .camera
        imagePickerController.cameraDevice = .rear
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()
    
    fileprivate var tesseract: G8Tesseract?
    
    /**
     Overrides the superclass' implementation.
     
     Additionally, this method sets the baseView of this view controller and also calls the interactors initialization method.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        initEventHandlers()

        addMenuItems()
        tesseract = G8Tesseract(language:"eng")
    }
    
    private func setView() {
        baseView = view as? PNCreateNoteView
        baseView?.delegate = self
        baseView?.contentTextView.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(PNCreateNoteViewController.setToEditable))
        baseView?.contentTextView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    private func initEventHandlers() {
        guard let realm = PNSharedRealm.configureDefaultRealm() else {
            print("Realm is nil")
            return
        }
        
        createEventHandler = PNCreateNoteEventHandler.init(note: note, notebook: notebook, realm: realm)
        
        guard let tesseract = G8Tesseract(language:"eng") else {
            print("Tesseract is nil")
            return
        }
        
        let scanDocumentInteractor = PNScanDocumentInteractor.init(imagePickerController: imagePickerController, tesseract: tesseract)
        let scanDocumenterPresenter = PNScanDocumentPresenter.init(scanDocumentInteractor: scanDocumentInteractor, output: self)
        scanDocumentInteractor.output = scanDocumenterPresenter
        scanDocumentEventHandler = scanDocumenterPresenter
    }
    
    /**
     Overrides the superclass' implementation.
     
     Additionally, this method sets the content of the baseView.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let  baseView = baseView, let contentText = baseView.contentTextView.attributedText, contentText.string.characters.count == 0 else {
            print("Base view is nil")
            return
        }
        
        if let contentText = note?.body, let attributedString = HTMLDecoder.decode(htmlString: contentText) {
            baseView.setContentTextView(content: attributedString)
            print(attributedString)
        }
        
        setNavigationBackButton()
    }
    
    private func setNavigationBackButton() {
        navigationController?.navigationBar.tintColor = PNConstants.tintColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let baseView = baseView, note == nil {
            baseView.setContentTextViewAsFirstResponder()
        }
    }
    
    /**
     Overrides the superclass' implementation.
     
     Additionally, this method triggers the updating of the note or creating a new note instance.
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        guard let contentAttributedText = baseView?.contentTextView.attributedText, contentAttributedText.string.characters.count > 0 else {
            print("Note is empty")
            return
        }
        
        createEventHandler?.saveNote(content: HTMLEncoder.encode(attributedText: baseView?.contentTextView.attributedText))
    }
    
    private func addMenuItems() {
        let menuController = UIMenuController.shared
        let boldTextMenuItem = UIMenuItem.init(title: "Bold", action: #selector(PNCreateNoteViewController.setTextToBold))
        let italicTextMenuItem = UIMenuItem.init(title: "Italic", action: #selector(PNCreateNoteViewController.setTextToItalic))
        let underlinedTextMenuItem = UIMenuItem.init(title: "Underline", action: #selector(PNCreateNoteViewController.setToUnderlined))
        menuController.menuItems = [boldTextMenuItem, italicTextMenuItem, underlinedTextMenuItem]
    }
    
    @objc private func setTextToBold() {
        let selectedRange = baseView?.contentTextView.selectedRange
        
        let fontBold = UIFont.init(name: "Lato-Bold", size: PNNoteTypographyContants.normalFontSize)
        let textViewText = baseView?.contentTextView.attributedText.mutableCopy() as? NSMutableAttributedString
        textViewText?.setAttributes([NSAttributedStringKey.font: fontBold as Any], range: selectedRange!)
        baseView?.contentTextView.attributedText = textViewText
    }
    
    @objc private func setTextToItalic() {
        let selectedRange = baseView?.contentTextView.selectedRange
        
        let fontItalic = UIFont.init(name: PNNoteTypographyContants.noteItalicFont, size: PNNoteTypographyContants.normalFontSize)
        let textViewText = baseView?.contentTextView.attributedText.mutableCopy() as? NSMutableAttributedString
        textViewText?.setAttributes([NSAttributedStringKey.font: fontItalic as Any], range: selectedRange!)
        baseView?.contentTextView.attributedText = textViewText
    }
    
    @objc private func setToUnderlined() {
        let selectedRange = baseView?.contentTextView.selectedRange
        
        let fontRegular = UIFont.init(name: PNNoteTypographyContants.noteNormalFont, size: PNNoteTypographyContants.normalFontSize)
        let textViewText = baseView?.contentTextView.attributedText.mutableCopy() as? NSMutableAttributedString
        
        textViewText?.addAttributes([NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.font: fontRegular as Any], range: selectedRange!)
        baseView?.contentTextView.attributedText = textViewText
    }
}

extension PNCreateNoteViewController: VIPERRouter {
    func routeAlertController(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

extension PNCreateNoteViewController: UITextViewDelegate {
    @objc func setToEditable() {
        baseView?.contentTextView.isEditable = true
        baseView?.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
    }
}

extension PNCreateNoteViewController: PNCreateNoteViewOutputDelegate {
    func scanDocumentTapped() {
        scanDocumentEventHandler?.scanDocument()
    }
}

extension PNCreateNoteViewController: PNScanDocumentPresenterOutput {
    func present(controller: UIViewController) {
        present(controller, animated: true, completion: nil)
    }
    
    func appendTextView(scannedFormattedText: NSAttributedString) {
        guard let contentAttributedText = baseView?.contentTextView.attributedText else {
           baseView?.contentTextView.attributedText = scannedFormattedText
            return
        }
        
        let mutableExistingAttributedText = NSMutableAttributedString.init(attributedString: contentAttributedText)
        mutableExistingAttributedText.append(scannedFormattedText)
        baseView?.contentTextView.attributedText = NSAttributedString.init(attributedString: mutableExistingAttributedText)
    }
}
