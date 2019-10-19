//
//  AppDelegate.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

var REF_CURRENT_USER: DatabaseReference?
var REF_USER_LIKES: DatabaseReference?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    let defaults = UserDefaults.standard
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()

        IQKeyboardManager.sharedManager().enable = true
        
        setupNavigationBars()
        
        if Auth.auth().currentUser != nil { // user is signed in
    
            let mainTabbar = mainStoryBoard.instantiateViewController(withIdentifier: "mainTabbar")
            window?.rootViewController = mainTabbar
            
             REF_CURRENT_USER = REF_USERS.child((Auth.auth().currentUser?.uid)!)
             REF_USER_LIKES = REF_CURRENT_USER?.child("likes")
            
        } else { // not signed in
            
            let loginVC = mainStoryBoard.instantiateViewController(withIdentifier: "signinVC")
            window?.rootViewController = loginVC
            
            REF_CURRENT_USER = nil
            REF_USER_LIKES = nil
        }

        return true
    }
    
    func setupNavigationBars() {
        
        UINavigationBar.appearance().tintColor = .white //color of navigation back
        UINavigationBar.appearance().barTintColor = UIColor(red: 63/255.0, green: 81/255.0, blue: 181/255.0, alpha: 1.0) //background color
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white] //color of title
        UINavigationBar.appearance().isTranslucent = false //non transparent
    }

 


}

