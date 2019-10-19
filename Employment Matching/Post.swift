//
//  Post.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import Foundation
import Firebase


class Post {
    
    var caption = ""
    var date: Double!
    var imageUrl = ""
    var likes = 0
    var Key = ""
    var posterID = ""
    var postRef: DatabaseReference!
    
    init(postKey: String, postData: [String:Any]) {
        
        if let caption = postData["caption"] as? String {
            self.caption = caption
        }
        
        if let date = postData["date"] as? Double {
            self.date = date
        }
        
        if let likes = postData["likes"] as? Int {
            self.likes = likes
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let ID = postData["posterID"] as? String {
            self.posterID = ID
        }
        
        self.Key = postKey
        postRef = REF_POSTS.child(postKey)
    }
    
    
    func changeLikesNumber(isAdding: Bool){
     
        if isAdding {
            likes = likes + 1
        } else {
            likes = likes - 1
        }
    
        postRef.child("likes").setValue(likes)
    }
    
    
}
