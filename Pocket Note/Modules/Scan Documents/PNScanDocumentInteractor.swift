//  DSScanDocumentInteractor.swift
//  Memo
//
//  Created by Hanet on 8/31/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit
import TesseractOCR

protocol PNScanDocumentPresenterOutput: class {
    func present(controller: UIViewController)
    func appendTextView(scannedFormattedText: NSAttributedString)
}

class PNScanDocumentInteractor: NSObject, PNScanDocumentInteractorInterface {
    private let imagePickerController: UIImagePickerController
    weak var output: PNScanDocumentInteractorOutput?
    fileprivate var tesseract: G8Tesseract
    
    init(imagePickerController: UIImagePickerController, tesseract: G8Tesseract) {
        self.imagePickerController = imagePickerController
        self.tesseract = tesseract
        super.init()
        
        imagePickerController.delegate = self        
    }
    
    func openCamera() {
        output?.present(controller: imagePickerController)
    }
}

extension PNScanDocumentInteractor: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            tesseract.image = UIImage.init(data: UIImageJPEGRepresentation(image, 1.0)!)
            tesseract.recognize()
            
            output?.appendTextView(scannedText: tesseract.recognizedText)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
