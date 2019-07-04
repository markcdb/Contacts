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

struct ErrorCodable: Codable {
    
    var statusCode: String
    var error: String?
}

struct ErrorResponse: LocalizedError {
    var statusCode: String
    var error: String?
    
    init(statusCode: String,
         error: String?) {
        
        self.statusCode = statusCode
        self.error      = error
    }
    
    init(errorCodable: ErrorCodable) {
        
        self.statusCode = errorCodable.statusCode
        self.error      = errorCodable.error
    }
    
    var errorDescription: String? {
        return error
    }
}
