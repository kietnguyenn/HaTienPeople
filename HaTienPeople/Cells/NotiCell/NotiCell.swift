//
//  NotiCell.swift
//  HaTienPeople
//
//  Created by Apple on 12/18/20.
//

import UIKit
//import InfiniteLayout

class NotiCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var fileLabel: UILabel!
    
    @IBOutlet weak var fileCollectionView: UICollectionView!
    
    var items = [File]() {
        didSet {
            print("items: \(items.count)")
        }
    }
    
    let cellId = "FileCell"
    
    var collectionViewCellOffset: CGFloat {
        get {
            return fileCollectionView.contentOffset.x
        }
        set {
            fileCollectionView.contentOffset.x = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupCollectionView() {
        fileCollectionView.register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
    }
    
    func setupCollectionViewDatasourceDelegate(datasourceDelegate: UICollectionViewDelegateFlowLayout & UICollectionViewDataSource, forRow rowIndex: Int) {
        fileCollectionView.delegate = datasourceDelegate
        fileCollectionView.dataSource = datasourceDelegate
        fileCollectionView.tag = rowIndex
        fileCollectionView.alwaysBounceHorizontal = true
        self.fileCollectionView.reloadData()
    }
 }

