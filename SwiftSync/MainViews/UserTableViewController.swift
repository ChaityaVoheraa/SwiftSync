//
//  UserTableViewController.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 30/03/24.
//

import UIKit

class UserTableViewController: UITableViewController {
    // MARK: - Vars

    var allUsers: [User] = []
    var filteredUsers: [User] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        
        tableView.tableFooterView = UIView()
        
        // createDummyUsers()
        setupSearchController()
        downloadUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredUsers.count : allUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        
        let user = searchController.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
        
        cell.configure(user: user)
        
        return cell
    }
    
    // MARK: - TableViewDelegates
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = searchController.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
        
        showUserProfile(user)
    }
    
    // MARK: - DownloadUsers

    private func downloadUsers() {
        FirebaseUserListener.shared.downloadAllUsersFromFirebase { allFirebaseUsers in
            
            self.allUsers = allFirebaseUsers
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - SetupSearchController

    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    private func filteredContentForSearchText(searchText: String) {
        filteredUsers = allUsers.filter { user -> Bool in
            user.username.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    // MARK: - UIScrollViewDelegate

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl!.isRefreshing {
            downloadUsers()
            refreshControl!.endRefreshing()
        }
    }
    
    // MARK: - Navigation

    private func showUserProfile(_ user: User) {
        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileView") as! ProfileTableViewController
        
        profileView.user = user
        navigationController?.pushViewController(profileView, animated: true)
    }
}

extension UserTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
