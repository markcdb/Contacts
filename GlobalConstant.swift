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
    static let profileHeaderCell   = "ProfileHeaderCell"
    static let fieldCell           = "FieldCell"
    static let deleteCell          = "DeleteCell"
}

struct Nibs {
    
    static let sectionHeader       = "SectionHeader"
}

struct StoryboardIDs {
    
    static let contactDetails      = "ContactDetailsVC"
    static let createContact       = "CreateContactsVC"
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
    
    static let darkGray         = UIColor.hex("ADADAD")
    static let semiDarkGray     = UIColor.hex("F0F0F0")
    static let whiteGray        = UIColor.hex("E9E9E9")
    static let lightGray        = UIColor.hex("D8D8D8")
    static let semiBlack        = UIColor.hex("4A4A4A")
    static let blueGreen        = UIColor.hex("50E3C2")
    static let descriptorGray   = UIColor.hex("A1A1A1")
    static let destructiveRed   = UIColor.hex("FE4431")
}

struct Fonts {
    
    static let helveticaNeue    = UIFont(name: "HelveticaNeue", size: 14.0)
    static let helveticaNeue16  = UIFont(name: "HelveticaNeue", size: 16.0)
    static let helveticaBold17  = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
}

struct Images {
    
    static let favorite                 = UIImage(named: "home_favourite")
    static let favorite_button          = UIImage(named: "favourite_button")
    static let favorite_button_selected = UIImage(named: "favourite_button_selected")
    static let placeholder_photo        = UIImage(named: "placeholder_photo")
}

struct Notifications {
    
    static let create = Notification.Name(rawValue: "Create")
    static let update = Notification.Name(rawValue: "Update")
    static let delete = Notification.Name(rawValue: "Delete")
    static let showKeyboard = UIResponder.keyboardWillShowNotification
    static let hideKeyboard = UIResponder.keyboardWillHideNotification
}

struct Storyboard {
    static let contacts = UIStoryboard(name: "Contacts", bundle: nil)
}

struct Strings {
    static let firstName = "First Name"
    static let lastName  = "Last Name"
    static let mobile    = "mobile"
    static let email     = "email"
    static let Cancel    = "Cancel"
    static let Next      = "Next"
    static let Done      = "Done"
    static let Ok        = "Ok"
    static let invalidFirstName = "Invalid First Name"
    static let invalidLastName  = "Invalid Last Name"
    static let invalidEmail = "Invalid Email Address"
    static let invalidPhone = "Invalid Phone Number"
    static let oops      = "Oops!"
    static let yey       = "Yey!"
    static let uhm       = "Uhmm"
    static let something = "Something went wrong!\nPlease try again."
    static let override  = "Are you sure you want to save the following changes?"
    static let willDelete     = "Are you sure you want to delete this person?"
    static let delete         = "Delete"
    static let createdContact = "Successfully created NEW Contact! :)"
    static let successDelete  = "Successfully deleted contact. :("
}
