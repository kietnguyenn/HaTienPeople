//
//  EventHandlingUserCell.swift
//  HTEmployee
//
//  Created by Apple on 1/25/21.
//

import UIKit

protocol EventHandlingUserCellDelegate: class {
    func didTapCallButton(with index: Int)
}

class EventHandlingUserCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var avaImageView: UIImageView!
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
        self.delegate.didTapCallButton(with: self.tag)
    }

    @IBAction func detailsButtonTapped(_ sender: UIButton) {
        
    }
    
    weak var delegate: EventHandlingUserCellDelegate!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(_ user: Owner, index: Int) {
        self.nameLabel.text = user.fullName
        self.phoneNumberLabel.text = user.phoneNumber
        self.selectionStyle = .none
        self.tag = index
    }
    
}
