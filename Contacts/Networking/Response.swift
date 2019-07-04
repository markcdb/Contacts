//
//  Response.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

struct Response {
    var statusCode: Int
    var data: Data
}

struct ErrorResponse: Codable, LocalizedError {
    var statusCode: Int
    var error: String?
    
    init(statusCode: Int,
         error: String?) {
        
        self.statusCode = statusCode
        self.error      = error
    }
}
