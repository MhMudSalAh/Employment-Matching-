//
//  SignInVC.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit
import Firebase


class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        
        let keyboardTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(keyboardTapGesture)
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    self.alertError(message: error!.localizedDescription)
                } else {
                    //UserDefaults.standard.set(user?.uid, forKey: "userID")
                    REF_CURRENT_USER = REF_USERS.child((Auth.auth().currentUser?.uid)!)
                    REF_USER_LIKES = REF_CURRENT_USER?.child("likes")
                    self.performSegue(withIdentifier: "signInToFeed", sender: nil)
                }
            })
        }
    }
    
    
    func alertError(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

}
