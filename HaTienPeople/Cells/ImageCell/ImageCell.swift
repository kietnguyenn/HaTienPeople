//
//  ImageCell.swift
//  Garage-admin
//
//  Created by Macbook on 5/1/20.
//  Copyright © 2020 LOU. All rights reserved.
//

import UIKit

protocol ImageCellDelegate: class {
    func didDelete(index: Int)
}

class ImageCell: UITableViewCell {
    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        self.delegate.didDelete(index: self.tag)
    }
    
    weak var delegate: ImageCellDelegate!
        
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        self.uploadImageView.contentMode = .scaleAspectFill
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.masksToBounds = true

    }
}

