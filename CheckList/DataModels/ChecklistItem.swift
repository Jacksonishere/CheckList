//
//  ChecklistItem.swift
//  CheckList
//
//  Created by Jackson Lu on 2/22/21.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    override init() {
        super.init()
        itemID = DataModel.nextChecklistItemID()
    }
    
    deinit {
      removeNotification()
    }

    
    func scheduleNotification() {
        removeNotification()
        
        if shouldRemind && dueDate > Date() {
            // create the notification content
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default

            // extract information from due date
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(
              [.year, .month, .day, .hour, .minute],
              from: dueDate)
            // notificiaotn trigger based on calender components
            let trigger = UNCalendarNotificationTrigger(
              dateMatching: components,
              repeats: false)
            // set it up using itemID which is unique as identifier in case u want to cancel it later
            let request = UNNotificationRequest(
              identifier: "\(itemID)",
              content: content,
              trigger: trigger)
            // add the notoification
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
}
