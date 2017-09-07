//
//  PNConstants.swift
//  Memo
//
//  Created by Hanet on 6/14/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import UIKit

/**
 The `PNConstants` struct contains globally available constants
 */
struct PNConstants {
    static let blueColor = UIColor.init(rgb:0x30C6291)
    static let redColor = UIColor.init(rgb:0xDA291C)
    static let redColorTheme = UIColor.init(rgb: 0xA71D31)
    
    static let tintColor = UIColor.black
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

struct PNNoteTypographyContants {
    static let noteNormalFont: String = "Lato-Light"
    static let noteItalicFont: String = "Lato-LightItalic"
    static let normalFontSize: CGFloat = 18.0
    static let headerFontSize: CGFloat = 22.0
}
