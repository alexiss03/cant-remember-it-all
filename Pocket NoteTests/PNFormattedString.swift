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
        let attributes = [NSFontAttributeName: UIFont.init(name: fontName, size: fontSize) as Any, NSForegroundColorAttributeName: UIColor.lightGray] as [String: Any]
        return NSAttributedString.init(string: text, attributes: attributes)
    }
}
