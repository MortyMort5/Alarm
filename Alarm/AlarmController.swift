//
//  AlarmController.swift
//  Alarm
//
//  Created by Sterling Mortensen on 2/6/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import Foundation

class AlarmController {
    
    var alarms: [Alarm]
    
    static let shared = AlarmController()
    
    private let alarmDictionaryArrayKey = "alarmDictionaryArray"
    
    init() {
        let moc1 = Alarm(fireTimeFromMidnight: 25200, name: "popTart", enabled: false, uuid: "1")
        let moc2 = Alarm(fireTimeFromMidnight: 25200, name: "daddyJoe", enabled: false, uuid: "2")
        let moc3 = Alarm(fireTimeFromMidnight: 25200, name: "mort", enabled: false, uuid: "3")
        let moc4 = Alarm(fireTimeFromMidnight: 25200, name: "nerd", enabled: false, uuid: "5")
        let moc5 = Alarm(fireTimeFromMidnight: 25200, name: "coders", enabled: false, uuid: "4")
        let moc6 = Alarm(fireTimeFromMidnight: 25200, name: "timeToSleep", enabled: false, uuid: "6")
        let moc7 = Alarm(fireTimeFromMidnight: 25200, name: "hippor", enabled: false, uuid: "7")
        
        alarms = [moc1, moc2, moc3, moc4, moc5, moc6, moc7]
        
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
    }
    
    private func saveToPersistentStore() {
        var alarmDictionaryArray: [[String: Any]] = []
        for alarm in alarms {
            let alarmDictionary = alarm.dictionaryRepresentation()
            alarmDictionaryArray.append(alarmDictionary)
        }
        UserDefaults.standard.set(alarmDictionaryArray, forKey: alarmDictionaryArrayKey)
    }
    
    func loadFromPersistentStore() {
        if let alarmDictionaryArray = UserDefaults.standard.value(forKey: alarmDictionaryArrayKey) as? [[String: Any]] {
            var alarmArray: [Alarm] = []
            
            for alarmDictionary in alarmDictionaryArray {
                if let alarm = Alarm(dictionary: alarmDictionary) {
                    alarmArray.append(alarm)
                }
            }
            self.alarms = alarmArray
        }
    }
    
    
    
}

















