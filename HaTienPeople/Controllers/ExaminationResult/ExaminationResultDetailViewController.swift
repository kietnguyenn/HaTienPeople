//
//  ExaminationResultDetailViewController.swift
//  HaTienPeople
//
//  Created by Nguyễn Anh Kiệt on 02/10/2021.
//

import Foundation
import UIKit

class ExaminationResultDetailViewController: BaseViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var examinationDateLabel: UILabel!
    @IBOutlet weak var executedUnitLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var resultItem : ResultCellItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chi tiết"
        self.showBackButton()
        guard let resultItem = resultItem,
              let profile = resultItem.profile,
              let name = profile.name,
              let birthdate = profile.dateOfBirth,
              let phone = profile.phone,
              let examinationDate = resultItem.examinationResultModel?.dateCreated,
              let executedUnit = resultItem.executedUnit,
              let reason = resultItem.profile?.reason,
              let result = resultItem.result
        else {return}
        self.nameLabel.text = "     " + name
        self.birthDateLabel.text = "     " + birthdate
        self.phoneNumberLabel.text = "     " + phone
        let configedDate = configDateTimeStringOnServerToDevice(dateString: examinationDate)
        self.examinationDateLabel.text = "     " + configedDate.date
        self.executedUnitLabel.text = "     " + executedUnit
        self.reasonLabel.text = "     " + reason
        self.resultLabel.text = "     " + result
    }
}
