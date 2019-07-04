//
//  Constant.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation
import UIKit

struct NetworkConfig {
    
    static let baseUrl = "http://gojek-contacts-app.herokuapp.com"
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
    static let sortKeys      = ["A", "B", "C", "D", "E", ""]
}

struct Cells {
    
    static let contactCell         = "ContactCell"
    static let loaderCell          = "LoaderCell"
    static let emptyCell           = "EmptyCell"
}

struct Nibs {
    
    static let sectionHeader       = "SectionHeader"
}

struct URLParameters {
    
    static let id = "$[id]"
}

struct Titles {
    
    static let contacts = "Contacts"
}

struct Segues {
    
    static let locationDetails = "LocationDetailsVC"
}

struct Colors {
    
    static let darkGray     = UIColor.hex("ADADAD")
    static let semiDarkGray = UIColor.hex("F0F0F0")
    static let whiteGray    = UIColor.hex("E9E9E9")
    static let lightGray    = UIColor.hex("D8D8D8")
    static let semiBlack    = UIColor.hex("4A4A4A")
    static let blueGreen    = UIColor.hex("50E3C2")
}

struct Fonts {
    
    static let helveticaNeue = UIFont(name: "HelveticaNeue", size: 14.0)
    static let helveticaBold17 = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
}

struct Images {
    
    static let favorite = UIImage(named: "home_favourite")
}

struct Notifications {
    
    static let create = Notification.Name(rawValue: "Create")
    static let update = Notification.Name(rawValue: "Update")
    static let delete = Notification.Name(rawValue: "Delete")
}
