//
//  NotificationDelegate.swift
//  Weather App
//
//  Created by Duy Dinh on 11/3/20.
//

import Foundation
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    
    func notificationRequest() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        notificationCenter.requestAuthorization(options: options) { didAllow, error in
            if didAllow {
                print("yes")
            } else {
                print("no")
            }
        }
    }
    
    func scheduleNotification(date: String, notificationBody: String, time: String) {
        let content = UNMutableNotificationContent()
        
        content.title = "The weather today, \(date)"
        content.body = notificationBody
        content.sound = .default
        
        var timeSchedule = DateComponents()
        let time = time.toDate(withFormat: "hh:mm a")
        timeSchedule = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: timeSchedule, repeats: true)
        let identifier = "The \(date) weather"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
