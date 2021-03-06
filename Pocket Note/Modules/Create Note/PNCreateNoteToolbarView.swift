//
//  PNCreateNoteToolbarView.swift
//  Memo
//
//  Created by Hanet on 8/11/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

protocol PNCreateNoteToolbarViewDelegate: class {
    func scanDocumentButtonTapped()
}

class PNCreateNoteToolbarView: UIView {
    @IBOutlet weak var toolbarButton1: UIButton! {
        didSet {
            header1Button = toolbarButton1
        }
    }
    @IBOutlet weak var toolbarButton2: UIButton! {
        didSet {
            underlineButton = toolbarButton2
        }
    }
    @IBOutlet weak var toolbarButton3: UIButton! {
        didSet {
            italicizedButton = toolbarButton3
        }
    }
    @IBOutlet weak var toolbarButton4: UIButton! {
        didSet {
            bulletsButton = toolbarButton4
        }
    }
    @IBOutlet weak var toolbarButton5: UIButton! {
        didSet {
            checklistButton = toolbarButton5
        }
    }
    @IBOutlet weak var toolbarButton6: UIButton! {
        didSet {
            cameraButton = toolbarButton6
        }
    }
    
    weak var header1Button: UIButton?
    weak var underlineButton: UIButton?
    weak var italicizedButton: UIButton?
    weak var bulletsButton: UIButton?
    weak var checklistButton: UIButton?
    weak var cameraButton: UIButton?
    
    weak var delegate: PNCreateNoteToolbarViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        toolbarButton1.setTitle("", for: .normal)
        toolbarButton2.setTitle("", for: .normal)
        toolbarButton3.setTitle("", for: .normal)
        toolbarButton4.setTitle("", for: .normal)
        toolbarButton5.setTitle("", for: .normal)

        let scanDocumentAttributedString = NSAttributedString.init(string: "Scan", attributes: [NSAttributedStringKey.font: UIFont.init(name: PNNoteTypographyContants.noteBoldFont, size: PNNoteTypographyContants.normalFontSize) ?? (Any).self])
        
        toolbarButton6.setAttributedTitle(scanDocumentAttributedString, for: .normal)
    }
    
    @IBAction func button6Tapped(_ sender: Any) {
        delegate?.scanDocumentButtonTapped()
    }
    
}
