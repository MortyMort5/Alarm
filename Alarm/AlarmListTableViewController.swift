//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Sterling Mortensen on 2/6/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController, SwitchTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell  else { return SwitchTableViewCell() }
        let alarm = AlarmController.shared.alarms[indexPath.row]
        cell.alarm = alarm
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func alarmValueChanged(_ cell: SwitchTableViewCell, selected: Bool) {
        guard let alarm = cell.alarm,
            let cellIndexPath = tableView.indexPath(for: cell) else { return }
        tableView.beginUpdates()
        alarm.enabled = selected
        tableView.reloadRows(at: [cellIndexPath], with: .automatic)
        tableView.endUpdates()
        
    }
    
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let alarm = AlarmController.shared.alarms[(indexPath as NSIndexPath).row]
        AlarmController.shared.toggleEnabled(for: alarm)
//        if alarm.enabled {
//            scheduleLocalNotification(for: alarm)
//        } else {
//            cancelLocalNotification(for: alarm)
//        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellToDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let alarm = AlarmController.shared.alarms[indexPath.row]
                if let alarmList = segue.destination as? AlarmDetailTableViewController {
                    alarmList.alarm = alarm
                }
            }
            
        }
    }
}
