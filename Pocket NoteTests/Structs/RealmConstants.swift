//
//  RealmConstants.swift
//  Memo
//
//  Created by Hanet on 5/25/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

import RealmSwift
import PSOperations

struct RealmConstants {
    static let serverURL = URL(string:"http://54.245.131.159:9080/")!

    static let networkOperationQueue = PSOperationQueue()
}
