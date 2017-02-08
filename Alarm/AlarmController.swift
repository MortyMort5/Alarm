//
//  AlarmController.swift
//  Alarm
//
//  Created by Sterling Mortensen on 2/6/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class AlarmController {
    
    var alarms: [Alarm] = []
    
    static let shared = AlarmController()
    
    private let alarmDictionaryArrayKey = "alarmDictionaryArray"
    
    init() {
        loadFromPersistentStore()
    }
    
    
    func addAlarm(fireTimeFromMidnight: TimeInterval, name: String) -> Alarm {
        let alarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(alarm)
        saveToPersistentStore()
        return alarm
    }
    
    func update(alarm: Alarm, fireTimeFromMidnight: TimeInterval, name: String) {
        alarm.fireTimeFromMidnight = fireTimeFromMidnight
        alarm.name = name
        saveToPersistentStore()
        print("update")
    }
    
    func delete(alarm: Alarm) {
        guard let index = alarms.index(of: alarm) else { return }
        alarms.remove(at: index)
        saveToPersistentStore()
    }
    
    func toggleEnabled(for alarm: Alarm) {
        if alarm.enabled == true {
            alarm.enabled = false
        } else {
                alarm.enabled = true
        }
        saveToPersistentStore()
    }
    
    static private var persistentAlarmsFilePath: String? {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        guard let documentsDirectory = directories.first as NSString? else { return nil }
        return documentsDirectory.appendingPathComponent("Alarms.plist")
    }
    
    private func saveToPersistentStore() {
        guard let filePath = type(of: self).persistentAlarmsFilePath else { return }
        NSKeyedArchiver.archiveRootObject(self.alarms, toFile: filePath)
    }
    
    func loadFromPersistentStore() {
        guard let filePath = type(of: self).persistentAlarmsFilePath else { return }
        guard let alarms = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Alarm] else { return }
        self.alarms = alarms
        print("loadFromPersistentStore")
    }
}

protocol AlarmScheduler {
    func scheduleLocalNotification(for alarm: Alarm)
    func cancelLocalNotification(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleLocalNotification(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.userInfo = ["UUID" : alarm.uuid]
        notificationContent.title = "Out Of Time Loser!"
        notificationContent.body = "Your alarm \(alarm.name) is out of time"
        notificationContent.sound = UNNotificationSound.default()
        
        guard let fireDate = alarm.fireDate else { return }
        let triggerDate = Calendar.current.dateComponents([.hour, .minute, .second], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable notification, \(error.localizedDescription)")
            }
            
        }
    }
    
    
    func cancelLocalNotification(for alarm: Alarm) {
       UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}














