//
//  HTMLSerializationHelper.swift
//  Memo
//
//  Created by Hanet on 8/29/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import  UIKit

struct HTMLEncoder {
   static func encode(attributedText: NSAttributedString?) -> String? {
    var htmlString: String? = ""
        
        let documentAttributes = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
        do {
            if let attributedText = attributedText {
                let htmlData = try attributedText.data(from:  NSRange.init(location: 0, length: attributedText.length), documentAttributes: documentAttributes)
                htmlString = String(data: htmlData, encoding: .utf8)
            }
        } catch {
            print("error creating HTML from Attributed String")
        }
        return htmlString
    }
}
