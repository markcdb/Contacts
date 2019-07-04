//
//  BaseTableviewCell.swift
//  FourSquare
//
//  Created by Mark Christian Buot on 02/02/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation
import UIKit

class BaseCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: BaseLabel?
    @IBOutlet weak var subTitleLabel: BaseLabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel?.font      = Fonts.helveticaNeue
    }
    
    internal func setProfileImageFrom(_ urlString: String,
                                      imageView: inout UIImageView?) {
        
        imageView?.setKFImage(with: urlString,
                              placeholder: Images.placeholder_photo,
                              shouldAnimate: true,
                              keepCurrentImageWhileLoading: false,
                              completion: nil)
    }
}
