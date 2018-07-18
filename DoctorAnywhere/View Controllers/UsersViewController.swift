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

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.allowsSelection = false
        }
    }
    
    fileprivate var loadingUsers = false
    var collectionViewDataSource: ItemsCollectionViewDataSource!
    var users : [User] = []
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.collectionView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        collectionView.addSubview(activityIndicator)
        
        return activityIndicator
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Users", comment: "Users")
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)
        loadingUsers = true
        activityIndicator.startAnimating()
        APIService.standard.getUsers(offset: 0) { (users, error) in
            if error == nil {
                if users?.count ?? 0 > 0 {
                    self.users = users!
                    self.collectionViewDataSource = ItemsCollectionViewDataSource(users: self.users, cellIdentifier: "ItemCell")
                    self.collectionView.dataSource = self.collectionViewDataSource
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.collectionView.reloadData()
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

// MARK:- CollectionView Data Source Methods
extension UsersViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.numberOfItems(inSection: indexPath.section) % 2 != 0 && indexPath.row == 0 {
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
        if (self.collectionView?.indexPathsForVisibleItems.contains([self.users.count - 1, 0]) ?? false) && !loadingUsers && hasMoreUser {
            loadingUsers = true
            let count = self.users.count
            APIService.standard.getUsers(offset: self.users.count) { (users, error) in
                if error == nil {
                    if users?.count ?? 0 > 0 {
                        self.users.append(contentsOf: users!)
                        self.collectionViewDataSource.users = self.users
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
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
