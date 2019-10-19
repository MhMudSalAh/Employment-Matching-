//
//  FeedCell.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class FeedPostCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    
    var likeAction : ((UITableViewCell) -> Void)?
    var visitAction : ((UITableViewCell) -> Void)?
    var viewPhotoAction : ((UITableViewCell) -> Void)?
    var postRef: DatabaseReference!
    
    override func awakeFromNib() {
        
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.visitProfile))
        let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.visitProfile))
        let viewPostPhotoTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewPostphoto))

        self.userProfileImage.addGestureRecognizer(profileTapGesture)
        self.userNameLabel.addGestureRecognizer(nameTapGesture)
        self.postImage.addGestureRecognizer(viewPostPhotoTapGesture)
    }
    
    
    func visitProfile(sender: UITapGestureRecognizer) {
        visitAction?(self)
    }
    
    func viewPostphoto(sender: UITapGestureRecognizer) {
        viewPhotoAction?(self)
    }
    

    @IBAction func likesBtnPressed(_ sender: Any) {
        likeAction?(self)
    }
  
    
    func configureCell(post: Post) {
        
        captionLabel.text = post.caption
        
        let posterRef = REF_USERS.child("\(post.posterID)")
        posterRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dic = snapshot.value as? [String: Any] {
                self.userNameLabel.text = dic["name"] as? String
                let posterUrl = URL(string: dic["imageUrl"] as! String)
                self.userProfileImage.kf.setImage(with: posterUrl)
            }
        })
        
        let from = Date(timeIntervalSince1970: TimeInterval(post.date))
        let to = Date()
        let components = Calendar.current.dateComponents([.second, .minute, .hour, .day, .weekOfMonth, .month], from: from, to: to)
        
        if components.second! > 0 && components.minute! == 0 {
            self.dateLabel.text = "\(components.second!) seconds ago"
        } else if components.minute! > 0 && components.hour! == 0 {
            self.dateLabel.text = "\(components.minute!) minutes ago"
        } else if components.hour! > 0 && components.day! == 0 {
            self.dateLabel.text = "\(components.hour!) hours ago"
        } else if components.day! > 0 && components.weekOfMonth! == 0 {
            self.dateLabel.text = "\(components.day!) days ago"
        } else if components.weekOfMonth! > 0 && components.month! == 0 {
            self.dateLabel.text = "\(components.weekOfMonth!) weeks ago"
        }
        
        
        if post.likes == 0 {
            likesLabel.text = ""
        } else if post.likes == 1 {
            likesLabel.text = "1 Like"
        } else {
            likesLabel.text = "\(post.likes) Likes"
        }
        
        let url = URL(string: post.imageUrl)
        postImage.kf.setImage(with: url)
        
        postRef = REF_USER_LIKES?.child(post.Key)
        
        postRef.observeSingleEvent(of: .value, with: { snapshot in
            if let _ = snapshot.value as? NSNull {
                self.likeBtn.setTitle("Like", for: .normal)
            } else {
                self.likeBtn.setTitle("Unlike", for: .normal)
            }
        })

    }
    
    
    
}
