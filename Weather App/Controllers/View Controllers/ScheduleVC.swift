//
//  ScheduleViewController.swift
//  Weather App
//
//  Created by Duy Dinh on 11/3/20.
//

import UIKit

class ScheduleVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var numberOfRows = 1
    private var selectedIndex = 0
    private var isOn = false
    private var timeLabel: String?
    private let userDefault = UserDefaults.standard
    var weather: Weather?
    
    let notifications = Notifications()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if userDefault.string(forKey: "time") != nil {
            isOn = true
        } else {
            isOn = false
        }

    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if userDefault.string(forKey: "time") != nil {
            userDefault.removeObject(forKey: "time")
            userDefault.setValue(timeLabel, forKey: "time")
        } else {
            userDefault.setValue(timeLabel, forKey: "time")
        }
    
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ScheduleVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows + (isOn ? 1: 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 && selectedIndex == 1 {
            return 240
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwitchTableViewCell
            switchCell.configure(isOn: isOn, delegate: self)
            return switchCell
        } else if indexPath.row == 1 && isOn {
            selectedIndex = 0
            let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as! TimePickerTableViewCell
            cell.delegate = self
            if userDefault.string(forKey: "time") != nil {
                cell.timeLabel.text = userDefault.string(forKey: "time")
            } else {
                let dateFormatter = DateFormatter()
                let currentDate = Date()
                dateFormatter.timeStyle = .short
                let dateString = dateFormatter.string(from: currentDate)
                cell.timeLabel.text = dateString
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.beginUpdates()
        if indexPath.row == 1 {
            selectedIndex = 1
        }
        tableView.endUpdates()
    }
}

extension ScheduleVC: SwitchCellDelegate {
    func toggle(isOn: Bool) {
        self.isOn = isOn
        if isOn {
            userDefault.removeObject(forKey: "time")
        }
        tableView.reloadData()
    }
}
    
extension ScheduleVC: TimePickerTableViewCellDelegate {
    func passData(with text: String) {
        self.timeLabel = text
    }
    
    
}
