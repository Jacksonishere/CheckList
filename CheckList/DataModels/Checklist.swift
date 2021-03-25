//
//  Checklist.swift
//  CheckList
//
//  Created by Jackson Lu on 3/6/21.
//

import UIKit

class Checklist: NSObject, Codable {
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    var name = ""
    var items = [ChecklistItem]()
    var iconName = "No Icon"
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}
