//
//  EventLogRow.swift
//  HTEmployee
//
//  Created by Apple on 11/27/20.
//

import UIKit

class EventLogRow: UITableViewCell {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var informationLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var eventLogTypeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
