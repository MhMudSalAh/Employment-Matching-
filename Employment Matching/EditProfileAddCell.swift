//
//  EditProfileAddCell.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit

class EditProfileAddCell: UITableViewCell {

    var addAction : ((UITableViewCell) -> Void)?
    
    @IBOutlet weak var valueField: UITextField!
    @IBAction func addValueBtnPressed(_ sender: Any) {
        addAction?(self)
    }

}
