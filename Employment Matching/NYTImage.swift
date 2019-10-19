//
//  NYTImage.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit
import NYTPhotoViewer

class NYTImage: NSObject, NYTPhoto {
    
    var image: UIImage?
    var imageData: Data?
    var placeholderImage: UIImage?
    let attributedCaptionTitle: NSAttributedString?
    let attributedCaptionSummary: NSAttributedString? = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: UIColor.gray])
    let attributedCaptionCredit: NSAttributedString? = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
    
    init(image: UIImage? = nil, imageData: Data? = nil, attributedCaptionTitle: NSAttributedString) {
        self.image = image
        self.imageData = imageData
        self.attributedCaptionTitle = attributedCaptionTitle
        super.init()
    }
    
}
