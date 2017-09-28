//
//  PNFormattedStringHelper.swift
//  Memo
//
//  Created by Hanet on 7/20/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

struct PNFormattedString {
    static func formattedString(text: String, fontName: String, fontSize: CGFloat) -> NSAttributedString {
        guard let attributes = [NSAttributedStringKey.font.rawValue: UIFont.init(name: fontName, size: fontSize) as Any, NSAttributedStringKey.foregroundColor: UIColor.lightGray] as? [NSAttributedStringKey: Any] else {
            return NSAttributedString.init()
        }
        
        return NSAttributedString.init(string: text, attributes: attributes)
    }
}
