//
//  NotiDetailViewController.swift
//  HaTienPeople
//
//  Created by Apple on 12/21/20.
//

import Foundation
import UIKit

class NotiDetailViewController: BaseViewController {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fileTableView: UITableView!
    
    var files = [File]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupTableView(_ tv: UITableView) {
        tv.delegate = self
        tv.dataSource = self
    }
}

extension NotiDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
