//
//  FancyImageView.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit

class FancyImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width/2.7
        //layer.cornerRadius = self.frame.height/3

    }


}
