//
//  Checklist.swift
//  CheckList
//
//  Created by Jackson Lu on 3/6/21.
//

import UIKit

class Checklist: NSObject, Codable {
    init(_ name: String) {
        self.name = name
        super.init()
    }
    
    var name = ""
    var items = [ChecklistItem]()
    
}
