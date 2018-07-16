//
//  UsersViewController.swift
//  DoctorAnywhere
//
//  Created by Saurabh Gupta on 16/07/18.
//  Copyright © 2018 saurabh. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {

    var users : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIService.standard.getUsers(offset: 0) { (users, error) in
            if error == nil {
                self.users = users
            }
        }
    }

}

