//
//  UsersTableViewDelegate.swift
//  DoctorAnywhere
//
//  Created by Saurabh Gupta on 16/07/18.
//  Copyright © 2018 saurabh. All rights reserved.
//

import Foundation
import UIKit

public class UsersTableViewDelegate: NSObject, UITableViewDelegate {
    
    var users: [User]
    
    init(users: [User]) {
        self.users = users
        
        super.init()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        // TODO: push to another view controller
    }
}
