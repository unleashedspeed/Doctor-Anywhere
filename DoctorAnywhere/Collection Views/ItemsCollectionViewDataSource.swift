//
//  ItemsCollectionViewDataSource.swift
//  DoctorAnywhere
//
//  Created by Saurabh Gupta on 17/07/18.
//  Copyright © 2018 saurabh. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

public class ItemsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var users: [User]
    var cellIdentifier: String
    
    init(users: [User], cellIdentifier: String) {
        self.users = users
        self.cellIdentifier = cellIdentifier
        
        super.init()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return users.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users[section].items?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ItemCollectionViewCell
        if let items = users[indexPath.section].items, let url = URL(string: items[indexPath.row]) {
            cell.itemImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! UserCollectionHeaderView
        
        let user = users[indexPath.section]
        if let url = URL(string: user.image ?? "") {
            headerView.userImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user_placeholder"))
        }
        headerView.userNameLabel.text = user.name
        
        return headerView
    }
}
