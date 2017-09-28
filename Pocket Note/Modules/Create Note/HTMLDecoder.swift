//
//  HTMLDecoder.swift
//  Memo
//
//  Created by Hanet on 8/29/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import UIKit

struct HTMLDecoder {
    static func decode(htmlString: String) -> NSAttributedString? {
        guard let data = htmlString.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil) else { return nil }
    
        html.beginEditing()
        html.enumerateAttribute(NSFontAttributeName, in: NSMakeRange(0, html.length), options: .init(rawValue: 0)) { (value, range, _) in
            if let font = value as? UIFont {
                let resizedFont = font.withSize(PNNoteTypographyContants.normalFontSize)
                html.addAttribute(NSFontAttributeName, value: resizedFont, range: range)
            }
        }
        let resizedFont = UIFont.init(name: PNNoteTypographyContants.noteNormalFont, size: PNNoteTypographyContants.normalFontSize)
        
        if html.length != 0 {
            html.addAttribute(NSFontAttributeName, value: resizedFont as Any, range: NSMakeRange(html.length-1, 1))
        }
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 3.0
        html.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, html.length))
        html.endEditing()
    
        return html
    }
}
