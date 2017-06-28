//
//  Date.swift
//  Memo
//
//  Created by Hanet on 6/27/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
import UIKit

extension Date {
    /**
     Computes the time interval since Jan 1, 2000 00:00:00.
     
     This is for the identifier of the `Note` and `Notebook` classes.
     */
    func timeStampFromDate() -> CGFloat {
        return CGFloat(CFAbsoluteTimeGetCurrent())
    }
    
    /**
     Converts a `Date` instance to a `String` value.
     */
    func displayString() -> String {
        let dateFormatter = DateFormatter()
        let date = self
        dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        return dateFormatter.string(from: date)
    }
}
