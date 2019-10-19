//
//  MoreVC.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit
import Firebase

class MoreVC: UITableViewController {

    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {

            performSegue(withIdentifier: "moreToEditProfile", sender: self)
        
        } else if indexPath.row == 1 {
        
            performSegue(withIdentifier: "moreToAbout", sender: nil)

        } else if indexPath.row == 2 {
            
            let alert = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
            let ok = UIAlertAction(title: "Sign Out", style: .destructive, handler:{_ in
              
                do {
                    
                    try Auth.auth().signOut()
                    
                    REF_POSTS.removeAllObservers()
                    REF_USERS.removeAllObservers()
                    REF_CURRENT_USER?.removeAllObservers()
                    
                    REF_CURRENT_USER = nil
                    REF_USER_LIKES = nil
                    
                    if Auth.auth().currentUser == nil {
                        let loginVC = self.mainStoryBoard.instantiateViewController(withIdentifier: "signinVC")
                        self.appDelegate.window?.rootViewController = loginVC
                    }
                    
                    
                } catch let signOutError {
                    print ("Error signing out: \(signOutError.localizedDescription)")
                }
                
                
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
}
