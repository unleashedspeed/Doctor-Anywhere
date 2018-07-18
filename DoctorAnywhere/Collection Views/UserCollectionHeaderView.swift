//
//  UserCollectionHeaderView.swift
//  DoctorAnywhere
//
//  Created by Saurabh Gupta on 18/07/18.
//  Copyright © 2018 saurabh. All rights reserved.
//

import UIKit

class UserCollectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var userImageView: UIImageView!{
        didSet {
            userImageView.layer.cornerRadius = userImageView.bounds.width/2
            userImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
}
