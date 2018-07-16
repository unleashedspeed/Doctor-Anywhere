//
//  UsersTableViewCell.swift
//  DoctorAnywhere
//
//  Created by Saurabh Gupta on 16/07/18.
//  Copyright © 2018 saurabh. All rights reserved.
//

import UIKit
import SDWebImage

class UsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var itemsCollectionView: UICollectionView! {
        didSet {
            itemsCollectionView.register(ItemCollectionViewCell.nib(), forCellWithReuseIdentifier: "ItemCell")
            itemsCollectionView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = userImageView.bounds.width/2
            userImageView.layer.masksToBounds = true
        }
    }
        
    func configure(name: String, imageURL: String) {
        userNameLabel.text = name
        if let url = URL(string: imageURL) {
            userImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user_placeholder"))
        }
    }
    
    override func prepareForReuse() {
        userImageView.image = #imageLiteral(resourceName: "user_placeholder")
        userNameLabel.text = ""
    }
}
