//
//  EventCell.swift
//  HaTienEmployeeLast
//
//  Created by Apple on 10/7/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func addShadow(){
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOpacity = 0.5
//        self.layer.shadowRadius = 2.0
//        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 120)
        contentView.layer.cornerRadius = 10.0
        contentView.clipsToBounds = true
    }
    
}
