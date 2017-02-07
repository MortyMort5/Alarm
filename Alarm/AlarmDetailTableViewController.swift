//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Sterling Mortensen on 2/6/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }

    
    @IBOutlet weak var alarmPicker: UIDatePicker!
    @IBOutlet weak var textFieldDetailView: UITextField!
    @IBOutlet weak var enableButtonTapped: UIButton!

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = textFieldDetailView.text,
            let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else { return }
        let timeIntervalSinceMidnight = alarmPicker.date.timeIntervalSince(thisMorningAtMidnight as Date)
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)
        } else {
            let alarm = AlarmController.shared.addAlarm(fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)
            self.alarm = alarm
        }
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enableButtonTapped(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    

    private func updateViews() {
        guard let alarm = alarm,
        let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight,
            isViewLoaded else { return }
        
        alarmPicker.setDate(Date(timeInterval: alarm.fireTimeFromMidnight, since: thisMorningAtMidnight), animated: false)
        textFieldDetailView.text = alarm.name
        self.title = alarm.name
    }
}
