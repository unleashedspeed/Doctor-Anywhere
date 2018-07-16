//
//  UsersViewController.swift
//  DoctorAnywhere
//
//  Created by Saurabh Gupta on 16/07/18.
//  Copyright © 2018 saurabh. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UsersTableViewCell.nib(), forCellReuseIdentifier: "UserCell")
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 48
            tableView.tableFooterView = UIView()
        }
    }

    var dataSource: UsersTableDataSource!
    var delegate: UsersTableViewDelegate!
    var users : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Users", comment: "Users")
        APIService.standard.getUsers(offset: 0) { (users, error) in
            if error == nil {
                if users?.count ?? 0 > 0 {
                    self.users = users!
                    self.dataSource  = UsersTableDataSource(users: self.users, cellIdentifier: "UserCell")
                    self.delegate = UsersTableViewDelegate(users: self.users)
                    self.tableView.dataSource = self.dataSource
                    self.tableView.delegate = self.delegate
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

}

