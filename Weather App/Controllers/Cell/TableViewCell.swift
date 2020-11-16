//
//  TableViewCell.swift
//  Weather App
//
//  Created by Duy Dinh on 11/2/20.
//

import UIKit

enum backgroundColor {
    case clear
    case rain
    case cloud
    
}
class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
