//
//  EditProfileFieldCell.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit

class EditProfileFieldCell: UITableViewCell {
    
    var updateAction : ((UITableViewCell) -> Void)?

    @IBOutlet weak var valueField: UITextField!
    @IBAction func updateValueBtnPressed(_ sender: Any) {
        updateAction?(self)
    }

}
