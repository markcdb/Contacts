//
//  URLHelper.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation
import UIKit

extension URL {
    
    static func isvalidURL(string: String?) -> Bool {
        
        if string != nil{
            if let url = NSURL(string: string ?? ""){
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        
        return false
    }
}
