//
//  SwitchTableViewCell.swift
//  Weather App
//
//  Created by Duy Dinh on 11/3/20.
//

import UIKit

protocol SwitchCellDelegate: class {
    func toggle(isOn: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var switchControl: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func valueChanged(_ sender: UISwitch) {
        delegate?.toggle(isOn: sender.isOn)
    }
    
    func configure(isOn: Bool, delegate: SwitchCellDelegate) {
        switchControl?.isOn = isOn
        self.delegate = delegate
    }
}
