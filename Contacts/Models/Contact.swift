//
//  Contact.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

struct Contact: Codable {
    
    var id: Int?
    var first_name: String?
    var last_name: String?
    var email: String?
    var phone_number: String?
    var profile_pic: String?
    var favorite: Bool?
    var created_at: String?
    var updated_at: String?
    var fullName: String {
        return (first_name ?? "") + " " + (last_name ?? "")
    }
    
    static func createStub() -> Contact {
        
        return Contact(id: 6027,
                       first_name: "Mark Christian SUT",
                       last_name: "SUT_LastName",
                       email: "SUT_email@SUT.com",
                       phone_number: nil,
                       profile_pic: nil,
                       favorite: nil,
                       created_at: nil,
                       updated_at: nil)
    }
}
