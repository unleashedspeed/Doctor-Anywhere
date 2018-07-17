//
//  ItemsCollectionViewDataSource.swift
//  DoctorAnywhere
//
//  Created by Saurabh Gupta on 17/07/18.
//  Copyright © 2018 saurabh. All rights reserved.
//

import Foundation
import UIKit

public class ItemsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var user: User
    var cellIdentifier: String
    
    init(user: User, cellIdentifier: String) {
        self.user = user
        self.cellIdentifier = cellIdentifier
        
        super.init()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.items?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ItemCollectionViewCell
        if let items = user.items, let url = URL(string: items[indexPath.row]) {
            cell.itemImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
        
        return cell
    }
}
