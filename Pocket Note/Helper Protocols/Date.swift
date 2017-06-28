//
//  Date.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import UIKit

extension Date {
    func timeStampFromDate() -> CGFloat {
        return CGFloat(CFAbsoluteTimeGetCurrent())
    }
}
