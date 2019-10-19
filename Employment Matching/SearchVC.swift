//
//  SearchVC.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import ARSLineProgress

class SearchVC: UITableViewController, UISearchBarDelegate {
    
    var usersArray = [User?]()
    var filteredUsers = [User?]()
    let searchBar = UISearchBar()
    var shouldShowSearchResults = false
    var visitorId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createSearchBar()
        
        REF_USERS.queryOrdered(byChild: "name").observe(.childAdded, with: { (snapshot) in
            
            let user = User(userKey: snapshot.key, userData: snapshot.value as! [String : Any])
            self.usersArray.append(user)
            self.tableView.insertRows(at: [IndexPath(row: self.usersArray.count-1, section: 0)], with: .automatic)
        })
    }
    
    
    
    func createSearchBar() {
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search for a Freelancer or company..."
        
        self.navigationItem.titleView = searchBar
    }

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if shouldShowSearchResults {
            return filteredUsers.count
        }
        
        return usersArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        let user : User?
        
        if shouldShowSearchResults {
            user = filteredUsers[indexPath.row]
        } else {
            user = usersArray[indexPath.row]
        }

        cell.name.text = user?.name
        let url = URL(string: (user?.imageUrl)!)
        cell.profileImage.kf.setImage(with: url)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user : User?

        if shouldShowSearchResults {
            user = filteredUsers[indexPath.row]
            visitorId = user?.ID
        } else {
            user = usersArray[indexPath.row]
            visitorId = user?.ID
        }
        
        performSegue(withIdentifier: "searchToProfile", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToProfile" {
            let visitorVC = segue.destination as! ProfileVC
            visitorVC.passedUserId = visitorId!
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredUsers = usersArray.filter{ user in
            
            let username = user?.name
            return (username?.lowercased().contains(searchText.lowercased()))!
        }
        
        if searchText != "" {
            shouldShowSearchResults = true
        } else {
            shouldShowSearchResults = false
        }
        
        tableView.reloadData()
    }
    
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        searchBar.endEditing(true)
    }

    
}
