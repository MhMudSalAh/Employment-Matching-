//
//  EditProfileImageCell.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit

class EditProfileImageCell: UITableViewCell {
    
    var updateAction : ((UITableViewCell) -> Void)?
    var imageAction : ((UITableViewCell) -> Void)?

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func updateImageBtnPressed(_ sender: Any) {
        updateAction?(self)
    }

    func choseProfileImage(sender: UITapGestureRecognizer) {
        imageAction?(self)
    }
    
    override func awakeFromNib() {
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.choseProfileImage))
        self.profileImage.addGestureRecognizer(profileTapGesture)
    }
    
    
}
