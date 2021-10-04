//
//  ExaminationResultCell.swift
//  HaTienPeople
//
//  Created by Nguyễn Anh Kiệt on 30/09/2021.
//

import UIKit

class ExaminationResultCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultDateLabel: UILabel!
    @IBOutlet weak var executedUnitNameLabel: UILabel!
    @IBOutlet weak var wrapperView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        wrapperView.layer.cornerRadius = 10.0
        wrapperView.clipsToBounds = true
        wrapperView.layer.borderWidth = 0.5
        wrapperView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setCellContent(_ item: ResultCellItem) {
        guard let profile = item.profile,
              let result = item.result,
              let resultDate = item.resultDate,
              let resultTime = item.resultTime
        else { return }
        self.nameLabel.text = profile.name
        self.resultLabel.text = item.result
        self.makeColorForResultLabel(with: result)
        self.resultDateLabel.text =  "\(resultTime) \(resultDate)"
        self.executedUnitNameLabel.text = item.executedUnit
        self.setupBigContent(resultDate)
    }
    
    func setupBigContent(_ dateString: String) {
        let dateSubString = String(dateString.prefix(2))
        let yearMonthSubstring = String(dateString.suffix(7))
        self.dateLabel.text = dateSubString
        self.monthYearLabel.text = yearMonthSubstring
        
    }
    
    func makeColorForResultLabel(with result: String) {
        
        switch result {
        case "DƯƠNG TÍNH":
            self.setColor(.green)
            break
        case "ÂM TÍNH":
            self.setColor(.red)
            break
        case "ÂM TÍNH(*)":
            self.setColor(.red)
            break
        case "NGHI NGỜ":
            self.setColor(.yellow)
            break
        case "CHƯA XÁC ĐỊNH":
            self.setColor(.orange)
            break
        case "KHÔNG XÁC ĐỊNH":
            self.setColor(.lightGray)
            break
        default:
            break
        }
    }
    
    fileprivate func setColor(_ color :UIColor) {
        self.resultLabel.tintColor = color
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
