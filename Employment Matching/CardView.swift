//
//  CardView.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit

class CardView: UIView {

    override func awakeFromNib() {
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 3.0
        
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowColor = UIColor(red: 157/255.0, green: 157/255.0, blue: 157/255.0, alpha: 1.0).cgColor
    }
}
