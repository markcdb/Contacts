//
//  ImageHelper.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func imageWithColor(_ color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0,
                          y: 0,
                          width: 1.0,
                          height: 0.5)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
