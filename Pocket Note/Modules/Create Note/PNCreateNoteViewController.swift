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
    var inputStyleMode: TextInputStyleMode = .bold
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
        
        if let unwrappedBaseView = baseView, let contentText = note?.body {
            var htmlString: String? = ""
            let attrStr = NSAttributedString.init(string: "Hello World", attributes: [NSFontAttributeName: UIFont.init(name: "Lato-Bold", size: 50.0)])
            let documentAttributes = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let htmlData = try attrStr.data(from: NSMakeRange(0, attrStr.length), documentAttributes:documentAttributes)
                htmlString = String(data:htmlData, encoding:String.Encoding.utf8)
                print(htmlString)
            }
            catch {
                print("error creating HTML from Attributed String")
            }
            
            do {
                if let attrStr = try NSAttributedString(data: (htmlString?.data(using: .utf8))!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)  as? NSAttributedString {
                    unwrappedBaseView.setContentTextView(content: attrStr)
                    print(attrStr)
                }
            }
            catch {
                print("error creating attributed string")
            }
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
    
    private func addMenuItems() {
        let menuController = UIMenuController.shared
        let boldMenuItem = UIMenuItem.init(title: "Bold", action: #selector(PNCreateNoteViewController.setTextToBold))
        menuController.menuItems = [boldMenuItem]
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
    
    func setTextToBold() {
        let selectedRange = baseView?.contentTextView.selectedRange
      
        let fontBold = UIFont.init(name: "Lato-Bold", size: PNNoteTypographyContants.normalFontSize)
        let textViewText = baseView?.contentTextView.attributedText.mutableCopy() as? NSMutableAttributedString
        textViewText?.setAttributes([NSFontAttributeName: fontBold as Any], range: selectedRange!)
        baseView?.contentTextView.attributedText = textViewText
    }
}
