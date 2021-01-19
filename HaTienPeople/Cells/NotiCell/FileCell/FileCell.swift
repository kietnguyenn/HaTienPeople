//
//  FileCell.swift
//  HaTienPeople
//
//  Created by Apple on 12/22/20.
//

import UIKit

class FileCell: UICollectionViewCell {
    
    @IBOutlet weak var fileNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func updateUI(index: Int, item: File) {
        if let fileId = item.id {
            print("fileId", fileId)
        }
        if let fileName = item.fileName {
            fileNameLabel.text = fileName
        } else {
            fileNameLabel.text = "No-name"
        }
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.clipsToBounds = true
        self.contentView.frame.size = CGSize(width: 30, height: 30)
    }
}
