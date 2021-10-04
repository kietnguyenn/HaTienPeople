//
//  MenuTableViewCell.swift
//  HaTienPeople
//
//  Created by Nguyễn Anh Kiệt on 29/09/2021.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuIconImageView: UIImageView!
    @IBOutlet weak var menuTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setContent(_ menuItem: MenuTableViewItem) {
        selectionStyle = .none
        self.menuTitleLabel.text = menuItem.title
        guard let image = UIImage(named: menuItem.icon) else { return }
        self.menuIconImageView.image = image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
