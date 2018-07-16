////
////  UsersTableViewDelegate.swift
////  DoctorAnywhere
////
////  Created by Saurabh Gupta on 16/07/18.
////  Copyright © 2018 saurabh. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//public class UsersTableViewDelegate: NSObject, UITableViewDelegate {
//    
//    var users: [User]
//    var loadMoreUsers: (() -> ())?
//    
//    init(users: [User]) {
//        self.users = users
//
//        super.init()
//    }
//    
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let user = users[indexPath.row]
//        
//        // TODO: push to another view controller
//    }
//
//    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if let cell = cell as? UsersTableViewCell {
//            cell.itemsCollectionView.dataSource = self
//        }
//    }
//}
//
//extension UsersTableViewDelegate {
//    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        loadMoreUsers?()
//    }
//}
//
