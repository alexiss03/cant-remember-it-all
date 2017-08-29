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
    
    /**
     Overrides the superclass' implementation.
     
     Additionally, this method sets the baseView of this view controller and also calls the interactors initialization method.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView = view as? PNCreateNoteView
        initEventHandlers()
        baseView?.contentTextView.delegate = self
        
        addMenuItems()
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
        
        let fontItalic = UIFont.init(name: "Lato-Italic", size: PNNoteTypographyContants.normalFontSize)
        let textViewText = baseView?.contentTextView.attributedText.mutableCopy() as? NSMutableAttributedString
        textViewText?.setAttributes([NSFontAttributeName: fontItalic as Any], range: selectedRange!)
        baseView?.contentTextView.attributedText = textViewText
    }
    
    @objc private func setToUnderlined() {
        let selectedRange = baseView?.contentTextView.selectedRange
        
        let fontRegular = UIFont.init(name: "Lato-Regular", size: PNNoteTypographyContants.normalFontSize)
        let textViewText = baseView?.contentTextView.attributedText.mutableCopy() as? NSMutableAttributedString
        
        textViewText?.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue, NSFontAttributeName: fontRegular as Any], range: selectedRange!)
        baseView?.contentTextView.attributedText = textViewText
    }
}

extension PNCreateNoteViewController: VIPERRouter {
    func routeAlertController(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

extension PNCreateNoteViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard range.location >= textView.attributedText.length else {
            return true
        }
        
        switch inputStyleMode {
            case .normal:
                return true
            case .bold:
                let fontBold = UIFont.init(name: "Lato-Bold", size: PNNoteTypographyContants.normalFontSize)
                let replacementText = NSMutableAttributedString.init(string: text, attributes: [NSFontAttributeName: fontBold as Any])
                
                let text = textView.attributedText.mutableCopy() as? NSMutableAttributedString
                text?.append(replacementText)
                textView.attributedText = text
                
            case .italicized:
                let fontItalic = UIFont.init(name: "Lato-Italic", size: PNNoteTypographyContants.normalFontSize)
                let replacementText = NSMutableAttributedString.init(string: text, attributes: [NSFontAttributeName: fontItalic as Any])
                
                let text = textView.attributedText.mutableCopy() as? NSMutableAttributedString
                text?.append(replacementText)
                textView.attributedText = text
                
            case .underline:
                let normalFont = UIFont.init(name: "Lato-Regular", size: PNNoteTypographyContants.normalFontSize)
                let replacementText = NSAttributedString(string: text, attributes:
                    [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue, NSFontAttributeName: normalFont as Any])
                
                let text = textView.attributedText.mutableCopy() as? NSMutableAttributedString
                text?.append(replacementText)
                textView.attributedText = text
            case .bulleted:
                let normalFont = UIFont.init(name: "Lato-Regular", size: PNNoteTypographyContants.normalFontSize)
                let replacementText = NSMutableAttributedString(string: text, attributes:
                    [NSFontAttributeName: normalFont as Any])
                
                if text.contains("\n") {
                    let attachment = NSTextAttachment.init()
                    attachment.image = UIImage.init(named: "IconBullet")
                    let bulletSize = CGSize.init(width: PNNoteTypographyContants.normalFontSize, height: PNNoteTypographyContants.normalFontSize)
                    attachment.bounds = CGRect.init(origin: attachment.bounds.origin, size: bulletSize)
                    replacementText.append(NSAttributedString.init(attachment: attachment))
                }
            
                let text = textView.attributedText.mutableCopy() as? NSMutableAttributedString
                text?.append(replacementText)
                textView.attributedText = text
            case .checklist:
                let normalFont = UIFont.init(name: "Lato-Regular", size: PNNoteTypographyContants.normalFontSize)
                let replacementText = NSMutableAttributedString(string: text, attributes:
                    [NSFontAttributeName: normalFont as Any])
                
                if text.contains("\n") {
                    let attachment = NSTextAttachment.init()
                    attachment.image = UIImage.init(named: "IconCheck")
                    let bulletSize = CGSize.init(width: PNNoteTypographyContants.normalFontSize, height: PNNoteTypographyContants.normalFontSize)
                    attachment.bounds = CGRect.init(origin: attachment.bounds.origin, size: bulletSize)
                    replacementText.append(NSAttributedString.init(attachment: attachment))
                }
                
                let text = textView.attributedText.mutableCopy() as? NSMutableAttributedString
                text?.append(replacementText)
                textView.attributedText = text
        }
        return false
    }
}
