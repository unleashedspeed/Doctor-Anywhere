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
            tableView.delegate = self
            tableView.allowsSelection = false
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 48
            tableView.tableFooterView = UIView()
        }
    }

    var dataSource: UsersTableDataSource!
//    var delegate: UsersTableViewDelegate?
    var collectionViewDataSource: ItemsCollectionViewDataSource!
    var users : [User] = []
    fileprivate var loadingUsers = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Users", comment: "Users")
        loadingUsers = true
        APIService.standard.getUsers(offset: 0) { (users, error) in
            if error == nil {
                if users?.count ?? 0 > 0 {
                    self.users = users!
                    self.dataSource  = UsersTableDataSource(users: self.users, cellIdentifier: "UserCell")
//                    self.delegate = UsersTableViewDelegate(users: self.users)
                    self.tableView.dataSource = self.dataSource
//                    self.tableView.delegate = self.delegate
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.loadingUsers = false
                    }
                }
            } else {
                //do error handling here
                self.loadingUsers = false
            }
        }
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? UsersTableViewCell {
            collectionViewDataSource = ItemsCollectionViewDataSource(user: users[indexPath.row], cellIdentifier: "ItemCell")
            cell.itemsCollectionView.dataSource = collectionViewDataSource
            cell.itemsCollectionView.delegate = self
            cell.itemsCollectionView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let userItemsCount = users[indexPath.row].items?.count ?? 0
        if userItemsCount % 2 == 0 {
            return ((tableView.bounds.width * CGFloat(userItemsCount / 2)) / 2) +  48
        } else if userItemsCount == 1 {
            return tableView.bounds.width + 48
        } else {
            return ((tableView.bounds.width * CGFloat(userItemsCount / 2))) + 48
        }
    }
}

// MARK:- CollectionView Data Source Methods
extension UsersViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.numberOfItems(inSection: 0) % 2 != 0 && indexPath.row == 0 {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
        }
        
//        let remainder = (Double(indexPath.item)/3).truncatingRemainder(dividingBy: 1)
//        if remainder == 0 {
//            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
//        }
        
        return CGSize(width: (collectionView.frame.size.width - 5) / 2, height: (collectionView.frame.size.width - 5) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

// MARK:- ScrollView Delegate Methods
extension UsersViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (self.tableView?.indexPathsForVisibleRows?.contains([0, self.users.count - 1]) ?? false) && !loadingUsers && self.users.count >= 10 {
            loadingUsers = true
            APIService.standard.getUsers(offset: self.users.count) { (users, error) in
                if error == nil {
                    if users?.count ?? 0 > 0 {
                        self.users.append(contentsOf: users!)
                        self.dataSource.users = self.users
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.loadingUsers = false
                        }
                    }
                } else {
                    //do error handling here
                    self.loadingUsers = false
                }
            }
        }
    }
}
