//
//  PNScanDocumentPresenter.swift
//  Memo
//
//  Created by Hanet on 9/21/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import TesseractOCR

protocol PNScanDocumentInteractorOutput: class {
    func present(controller: UIViewController)
    func appendTextView(scannedText: String)
}

protocol PNScanDocumentVIPEREventHandler: VIPEREventHandler {
    func scanDocument()
}

protocol PNScanDocumentInteractorInterface: class {
    func openCamera()
}

class PNScanDocumentPresenter: PNScanDocumentVIPEREventHandler, PNScanDocumentInteractorOutput {
    private let interactor: PNScanDocumentInteractorInterface
    private weak var output: PNScanDocumentPresenterOutput?
    
    init(scanDocumentInteractor: PNScanDocumentInteractor, output: PNScanDocumentPresenterOutput) {
        self.interactor = scanDocumentInteractor
        self.output = output
    }
    
    func scanDocument() {
        interactor.openCamera()
    }
    
    func present(controller: UIViewController) {
        output?.present(controller: controller)
    }
    
    func appendTextView(scannedText: String) {
        output?.appendTextView(scannedFormattedText: NSAttributedString.init(string: scannedText, attributes: [NSFontAttributeName: UIFont.init(name: PNNoteTypographyContants.noteNormalFont, size: PNNoteTypographyContants.normalFontSize) ?? (Any).self]))
    }
}



