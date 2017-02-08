//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Sterling Mortensen on 2/6/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmDetailTableViewController: UITableViewController, AlarmScheduler {
    
    var alarm: Alarm? {
        didSet {
            if isViewLoaded {
                updateViews()
            } else {
                loadView()
                updateViews()
            }
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
            cancelLocalNotification(for: alarm)
            scheduleLocalNotification(for: alarm)
        } else {
            let alarm = AlarmController.shared.addAlarm(fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)
            self.alarm = alarm
            scheduleLocalNotification(for: alarm)
        }
        let _ = navigationController?.popViewController(animated: true)
        print("saveButtonTapped")
    }
    
    @IBAction func enableButtonTapped(_ sender: Any) {
        guard let alarm = alarm else { return }
        AlarmController.shared.toggleEnabled(for: alarm)
        if alarm.enabled {
            scheduleLocalNotification(for: alarm)
        } else {
            cancelLocalNotification(for: alarm)
        }
        updateViews()
        print("Enable")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        print("viewDidLoad")
    }
    

    private func updateViews() {
        print("updateViews")
        guard let alarm = alarm,
        let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight,
            isViewLoaded else { return }
        alarmPicker.setDate(Date(timeInterval: alarm.fireTimeFromMidnight, since: thisMorningAtMidnight), animated: false)
        textFieldDetailView.text = alarm.name
        
        enableButtonTapped.isHidden = false
        if alarm.enabled {
            enableButtonTapped.setTitle("Disable", for: UIControlState())
            enableButtonTapped.setTitleColor(.white, for: UIControlState())
            enableButtonTapped.backgroundColor = .red
        } else {
            enableButtonTapped.setTitle("Enable", for: UIControlState())
            enableButtonTapped.setTitleColor(.blue, for: UIControlState())
            enableButtonTapped.backgroundColor = .gray
        }
        self.title = alarm.name
        
    }
}


























