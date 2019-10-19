//
//  User.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import Foundation

class User {
    
    var ID = ""
    var name = ""
    var type = ""
    var imageUrl = ""
    var website = ""
    var email = ""
    var phone = ""
    var location = ""
    var tags = [""]
    var selections = [""]
    var skills = [""]
    var experience = ""
    var gender = ""
    var address = ""
    
    init() {
        
    }
    
    init(userKey: String, userData: [String:Any]) {
        
        if let name = userData["name"] as? String {
            self.name = name
        }
        
        if let imageUrl = userData["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        self.ID = userKey
    }
    
}
