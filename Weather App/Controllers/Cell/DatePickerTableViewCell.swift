//
//  DatePickerTableViewCell.swift
//  Weather App
//
//  Created by Duy Dinh on 11/3/20.
//

import UIKit

protocol TimePickerTableViewCellDelegate: class {
    func passData(with text: String)
}

class TimePickerTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!

    weak var delegate: TimePickerTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        datePicker.datePickerMode = .time
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .short
        
        let stringDate = dateFormatter.string(from: datePicker.date)
        timeLabel.text = stringDate
        delegate?.passData(with: stringDate)
    }

}
