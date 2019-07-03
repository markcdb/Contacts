//
//  Response.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

struct Response {
    var status: Int
    var data: Data
}

struct ErrorResponse: LocalizedError {
    var status: Int
    var errorDescription: String?
    
    init(status: Int,
         errorDescription: String?) {
        
        self.status           = status
        self.errorDescription = errorDescription
    }
}
