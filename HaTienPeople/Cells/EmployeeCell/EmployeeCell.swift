//
//  EmployeeCell.swift
//  HTEmployee
//
//  Created by Apple on 12/14/20.
//

import UIKit

class EmployeeCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var avaImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
