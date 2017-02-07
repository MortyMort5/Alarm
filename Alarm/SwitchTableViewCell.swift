//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Sterling Mortensen on 2/6/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    weak var delegate: SwitchTableViewCellDelegate?

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        delegate?.alarmValueChanged(self, selected: sender.isOn)
    }
    
    var alarm: Alarm? {
        didSet {
            guard let alarm = alarm else { return }
            timeLabel.text = alarm.fireTimeAsString
            nameLabel.text = alarm.name
            alarmSwitch.isOn = alarm.enabled
        }
    }
    
}

protocol SwitchTableViewCellDelegate: class {
    func alarmValueChanged(_ cell: SwitchTableViewCell, selected: Bool)
}
