//
//  CustomerCell.swift
//  HTEmployee
//
//  Created by Apple on 2/23/21.
//

import UIKit

class CustomerCell: UITableViewCell {
    
    @IBOutlet weak var cusNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
