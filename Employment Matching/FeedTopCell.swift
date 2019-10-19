//
//  FeedTopCell.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit

class FeedTopCell: UITableViewCell {

    @IBOutlet weak var postTextField: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var addImageBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        postTextField.layer.borderColor = UIColor.gray.cgColor
        postTextField.layer.borderWidth = 0.5
    }
    
    
    var postAction : ((UITableViewCell) -> Void)?
    var addImageAction : ((UITableViewCell) -> Void)?

    
    @IBAction func postBtnPressed(_ sender: Any) {
        postAction?(self)
    }
    
    
    @IBAction func addImageBtnPressed(_ sender: Any) {
        addImageAction?(self)
    }
    
  

}
