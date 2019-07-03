//
//  Constant.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

struct NetworkConfig {
    
    static let baseUrl = "http://gojek-contacts-app.herokuapp.com/"
}

struct Paths {
    
    static let testPath = "XCTestConfigurationFilePath"
    static let contacts = "/contacts.json" //GET & POST
    static let contact  = "/contacts/\(URLParameters.id).json" //GET, PUT & DELETE
}

struct Keys {
    
    static let language      = "language"
    static let statusCode    = "statusCode"
    static let message       = "message"
    static let response      = "response"
    static let venues        = "venues"
    static let error         = "error"
    static let hosts         = "hosts"
    static let hostResponses = "hostResponses"
}

struct Cells {
    
    static let locationCell        = "LocationCell"
    static let loaderCell          = "LoaderCell"
    static let permissionCell      = "PermissionCell"
    static let locationTitleCell   = "LocationTitleCell"
    static let locationDetailsCell = "LocationDetailsCell"
}

struct URLParameters {
    
    static let id = "$[id]"
}

struct Titles {}

struct Segues {
    
    static let locationDetails = "LocationDetailsVC"
}
