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

enum TextInputStyleMode {
    case bold
    case underline
    case italicized
    case bulleted
    case checklist
    case normal
}

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
    private var eventHandler: PNCreateNoteVIPEREventHandler?
    
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
        
        guard let  baseView = baseView else {
            print("Base view is nil")
            return
        }
        
        if let contentText = note?.body {
            if let attributedString = HTMLDecoder.decode(htmlString: contentText) {
                baseView.setContentTextView(content: attributedString)
                print(attributedString)
            }
        }
        
        setNavigationBackButton()
    }
    
    private func setNavigationBackButton() {
        navigationController?.navigationBar.tintColor = PNConstants.tintColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.backItem?.title = ""
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
        guard let contentAttributedText = baseView?.contentTextView.attributedText, contentAttributedText.string.characters.count > 0 else {
            print("Note is empty")
            return
        }
        
        eventHandler?.saveNote(content: HTMLEncoder.encode(attributedText: baseView?.contentTextView.attributedText))
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
        textViewText?.setAttributes([NSFontAttributeName: fontBold as Any], range: selectedRange!)
        baseView?.contentTextView.attributedText = textViewText
    }
    
    @objc private func setTextToItalic() {
        let selectedRange = baseView?.contentTextView.selectedRange
        
        let fontItalic = UIFont.init(name: PNNoteTypographyContants.noteItalicFont, size: PNNoteTypographyContants.normalFontSize)
        let textViewText = baseView?.contentTextView.attributedText.mutableCopy() as? NSMutableAttributedString
        textViewText?.setAttributes([NSFontAttributeName: fontItalic as Any], range: selectedRange!)
        baseView?.contentTextView.attributedText = textViewText
    }
    
    @objc private func setToUnderlined() {
        let selectedRange = baseView?.contentTextView.selectedRange
        
        let fontRegular = UIFont.init(name: PNNoteTypographyContants.noteNormalFont, size: PNNoteTypographyContants.normalFontSize)
        let textViewText = baseView?.contentTextView.attributedText.mutableCopy() as? NSMutableAttributedString
        
        textViewText?.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue, NSFontAttributeName: fontRegular as Any], range: selectedRange!)
        baseView?.contentTextView.attributedText = textViewText
    }
    
    private func takeAPhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func uploadFromGalleryTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        imagePicker.allowsEditing  = true
        present(imagePicker, animated: true, completion: nil)
    }
}

extension PNCreateNoteViewController: VIPERRouter {
    func routeAlertController(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

extension PNCreateNoteViewController: UITextViewDelegate {
    func setToEditable() {
        baseView?.contentTextView.isEditable = true
        baseView?.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
    }
}

extension PNCreateNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            tesseract?.image = UIImage.init(data: UIImageJPEGRepresentation(image, 1.0)!)
            tesseract?.recognize()
            
            if let recognizedText = tesseract?.recognizedText {
                baseView?.contentTextView.attributedText = NSAttributedString.init(string: recognizedText)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PNCreateNoteViewController: PNCreateNoteViewOutputDelegate {
    func scanDocumentTapped() {
        let imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}
