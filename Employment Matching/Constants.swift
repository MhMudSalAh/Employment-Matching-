//
//  Constants.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import Foundation
import Firebase

//base urls
let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

// database refrences
let REF_USERS = DB_BASE.child("users")
let REF_POSTS = DB_BASE.child("posts")

//storage refrences
let REF_POST_PICS = STORAGE_BASE.child("postPics")
let REF_PROFILE_PICS = STORAGE_BASE.child("profilePics")

