//
//  BaseContactsVM.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

class BaseContactsVM: BaseVMRepo<ContactsRepository> {
    
    internal var contacts: [String: [Contact]] = [:]
    internal var sortingKeys: [String]         = []

    override init(delegate: BaseVMDelegate) {
        super.init(delegate: delegate)
    }
    
    internal func getContactsCountAt(_ section: Int) -> Int {
        guard section < contacts.count else { return 0 }
        let key = sortingKeys[section]

        return contacts[key]?.count ?? 0
    }
    
    internal func getContactAt(_ indexPath: IndexPath) -> Contact? {
        guard indexPath.section < contacts.count else { return nil }
        let key = sortingKeys[indexPath.section]
        
        guard indexPath.row < contacts[key]?.count ?? 0 else { return nil }
        return contacts[key]?[indexPath.row]
    }
    
    internal func getFullNameAt(_ indexPath: IndexPath) -> String? {
        guard indexPath.section < contacts.count else { return nil }
        let key = sortingKeys[indexPath.section]

        guard indexPath.row < contacts[key]?.count ?? 0 else { return nil }
        return contacts[key]?[indexPath.row].fullName
    }
    
    internal func getFirstNameAt(_ indexPath: IndexPath) -> String? {
        guard indexPath.section < contacts.count else { return nil }
        let key = sortingKeys[indexPath.section]
        
        guard indexPath.row < contacts[key]?.count ?? 0 else { return nil }
        return contacts[key]?[indexPath.row].first_name
    }
    
    internal func getLastNameAt(_ indexPath: IndexPath) -> String? {
        guard indexPath.section < contacts.count else { return nil }
        let key = sortingKeys[indexPath.section]
        
        guard indexPath.row < contacts[key]?.count ?? 0 else { return nil }
        return contacts[key]?[indexPath.row].last_name
    }
    
    internal func getIsFavorite(_ indexPath: IndexPath) -> Bool {
        guard indexPath.section < contacts.count else { return false }
        let key = sortingKeys[indexPath.section]
        
        guard indexPath.row < contacts[key]?.count ?? 0 else { return false }
        return contacts[key]?[indexPath.row].favorite ?? false
    }
    
    internal func getProfileUrl(_ indexPath: IndexPath) -> String? {
        guard indexPath.section < contacts.count else { return nil }
        let key = sortingKeys[indexPath.section]
        
        guard indexPath.row < contacts[key]?.count ?? 0 else { return nil }
        let urlString = contacts[key]?[indexPath.row].profile_pic
        
        if URL.isvalidURL(string: urlString) {
            return urlString
        } else {
            return NetworkConfig.baseUrl.appending(urlString ?? "")
        }
    }
    
    internal func getSortingKeys() -> [String] {
        
        return sortingKeys
    }
    
    internal func getSortingKeysCount() -> Int {
        
        return sortingKeys.count
    }
}

class BaseContactVM: BaseVMRepo<ContactsRepository> {
    
    internal var contact: Contact?
    internal var idForUpdate: String?
    
    override init(delegate: BaseVMDelegate) {
        super.init(delegate: delegate)
    }
    
    internal func getContact() -> Contact? {
       
        return contact
    }
    
    internal func getFullName() -> String? {
        
        return contact?.fullName
    }
    
    internal func getFirstName() -> String? {
     
        return contact?.first_name
    }
    
    internal func getLastName() -> String? {
      
        return contact?.last_name
    }
    
    internal func getIsFavorite() -> Bool {
       
        return contact?.favorite ?? false
    }
    
    internal func getProfileUrl() -> String? {
        let urlString = contact?.profile_pic
        
        if URL.isvalidURL(string: urlString) {
            return urlString
        } else {
            return NetworkConfig.baseUrl.appending(urlString ?? "")
        }
    }
}
