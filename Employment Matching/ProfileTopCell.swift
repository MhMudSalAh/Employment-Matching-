//
//  ProfileTopCell.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit

class ProfileTopCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var viewPhotoAction : ((UITableViewCell) -> Void)?

    override func awakeFromNib() {
        let viewPostPhotoTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewProfilephoto))
        self.profileImage.addGestureRecognizer(viewPostPhotoTapGesture)
    }
    
    func viewProfilephoto(sender: UITapGestureRecognizer) {
        viewPhotoAction?(self)
    }
    
    
    
}
