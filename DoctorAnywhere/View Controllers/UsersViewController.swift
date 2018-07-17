//
//  UsersViewController.swift
//  DoctorAnywhere
//
//  Created by Saurabh Gupta on 16/07/18.
//  Copyright © 2018 saurabh. All rights reserved.
//

import UIKit

var hasMoreUser = true

class UsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UsersTableViewCell.nib(), forCellReuseIdentifier: "UserCell")
            tableView.delegate = self
            tableView.allowsSelection = false
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 48
            tableView.allowsSelection = false
        }
    }
    
    fileprivate var loadingUsers = false
    var dataSource: UsersTableDataSource!
    var collectionViewDataSource: ItemsCollectionViewDataSource!
    var users : [User] = []
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.tableView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        tableView.addSubview(activityIndicator)
        
        return activityIndicator
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Users", comment: "Users")
        loadingUsers = true
        activityIndicator.startAnimating()
        APIService.standard.getUsers(offset: 0) { (users, error) in
            if error == nil {
                if users?.count ?? 0 > 0 {
                    self.users = users!
                    self.dataSource  = UsersTableDataSource(users: self.users, cellIdentifier: "UserCell")
                    self.tableView.dataSource = self.dataSource
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                        self.loadingUsers = false
                    }
                }
            } else {
                //do error handling here
                self.loadingUsers = false
                self.activityIndicator.stopAnimating()
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
        } else {
            let tableViewHeight = tableView.bounds.width + ((tableView.bounds.width * CGFloat((Double(userItemsCount / 2) * 0.5)))) + 48
            let totalInterimSpacing = CGFloat((userItemsCount / 2) * 5)
            return tableViewHeight - totalInterimSpacing
        }
    }
}

// MARK:- CollectionView Data Source Methods
extension UsersViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.numberOfItems(inSection: 0) % 2 != 0 && indexPath.row == 0 {
            return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.width)
        }
        
        return CGSize(width: (collectionView.bounds.size.width - 5) / 2, height: (collectionView.bounds.size.width - 5) / 2)
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
        if (self.tableView?.indexPathsForVisibleRows?.contains([0, self.users.count - 1]) ?? false) && !loadingUsers && hasMoreUser {
            loadingUsers = true
            let count = self.users.count
            APIService.standard.getUsers(offset: self.users.count) { (users, error) in
                if error == nil {
                    if users?.count ?? 0 > 0 {
                        self.users.append(contentsOf: users!)
                        self.dataSource.users = self.users
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.loadingUsers = false
                            self.tableView.scrollToRow(at: IndexPath(row: count - 1, section: 0), at: .top, animated: false)
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
