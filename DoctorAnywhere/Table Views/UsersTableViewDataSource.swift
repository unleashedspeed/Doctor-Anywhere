//
//  UsersTableViewDataSource.swift
//  DoctorAnywhere
//
//  Created by Saurabh Gupta on 16/07/18.
//  Copyright © 2018 saurabh. All rights reserved.
//

import Foundation
import UIKit

public class UsersTableDataSource: NSObject, UITableViewDataSource {
    
    var users: [User]
    var cellIdentifier: String
    
    init(users: [User], cellIdentifier: String) {
        self.users = users
        self.cellIdentifier = cellIdentifier
        
        super.init()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UsersTableViewCell
        let user = users[indexPath.row]
        cell.configure(name: user.name ?? "", imageURL: user.image ?? "")
        
        return cell
    }
    
}

