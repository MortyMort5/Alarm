//
//  Alarm.swift
//  Alarm
//
//  Created by Sterling Mortensen on 2/6/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import Foundation
import UIKit

class Alarm: Equatable {
    
    
    private let fireTimeFromMidnightKey = "fireTimeFromMidnight"
    private let nameKey = "name"
    private let enabledKey = "enabled"
    private let uuidKey = "uuid"
    
    
    // MARK: - Properties and Memberwise Initializer
    var fireTimeFromMidnight: TimeInterval
    var name: String
    var enabled: Bool
    let uuid: String
    
    init(fireTimeFromMidnight: TimeInterval, name: String, enabled: Bool = true, uuid: String = UUID().uuidString) {
        self.fireTimeFromMidnight = fireTimeFromMidnight
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
    }
    
    func dictionaryRepresentation() -> [String: Any] {
        return [
            self.fireTimeFromMidnightKey: fireTimeFromMidnight,
            self.nameKey: name,
            self.enabledKey: enabled,
            self.uuidKey: uuid
        ]
    }
    
    
    init?(dictionary: [String: Any]) {
        guard let fireTimeFromMidnight = dictionary[fireTimeFromMidnightKey] as? TimeInterval,
            let name =  dictionary[nameKey] as? String,
            let enabled = dictionary[enabledKey] as? Bool,
            let uuid = dictionary[uuidKey] as? String else  {
                
            return nil
        }
        self.fireTimeFromMidnight = fireTimeFromMidnight
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
    }
    
    
    
    var fireDate: Date? {
        guard let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else {return nil}
        let fireDateFromThisMorning = Date(timeInterval: fireTimeFromMidnight, since: thisMorningAtMidnight as Date)
        return fireDateFromThisMorning
    }
    
    var fireTimeAsString: String {
        let fireTimeFromMidnight = Int(self.fireTimeFromMidnight)
        var hours = fireTimeFromMidnight/60/60
        let minutes = (fireTimeFromMidnight - (hours*60*60))/60
        if hours >= 13 {
            return String(format: "%2d:%02d PM", arguments: [hours - 12, minutes])
        } else if hours >= 12 {
            return String(format: "%2d:%02d PM", arguments: [hours, minutes])
        } else {
            if hours == 0 {
                hours = 12
            }
            return String(format: "%2d:%02d AM", arguments: [hours, minutes])
        }
    }
    
    
    
}


func ==(lhs: Alarm, rhs: Alarm) -> Bool {
    return lhs.uuid == rhs.uuid
}



