//
//  BaseContactsVM.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

class BaseContactsVM: BaseVM {
    
    internal var contacts: [String: [Contact]] = [:]
    internal var sortingKeys: [String]         = []
    
    override init(delegate: BaseVMDelegate) {
        super.init(delegate: delegate)
    }
    
    func getContactsCountAt(_ section: Int) -> Int {
        guard section < contacts.count else { return 0 }
        let key = sortingKeys[section]

        return contacts[key]?.count ?? 0
    }
    
    func getContactAt(_ indexPath: IndexPath) -> Contact? {
        guard indexPath.section < contacts.count else { return nil }
        let key = sortingKeys[indexPath.section]
        
        guard indexPath.row < contacts[key]?.count ?? 0 else { return nil }
        return contacts[key]?[indexPath.row]
    }
    
    func getFullNameAt(_ indexPath: IndexPath) -> String? {
        guard indexPath.section < contacts.count else { return nil }
        let key = sortingKeys[indexPath.section]

        guard indexPath.row < contacts[key]?.count ?? 0 else { return nil }
        return contacts[key]?[indexPath.row].fullName
    }
    
    func getFirstNameAt(_ indexPath: IndexPath) -> String? {
        guard indexPath.section < contacts.count else { return nil }
        let key = sortingKeys[indexPath.section]
        
        guard indexPath.row < contacts[key]?.count ?? 0 else { return nil }
        return contacts[key]?[indexPath.row].first_name
    }
    
    func getLastNameAt(_ indexPath: IndexPath) -> String? {
        guard indexPath.section < contacts.count else { return nil }
        let key = sortingKeys[indexPath.section]
        
        guard indexPath.row < contacts[key]?.count ?? 0 else { return nil }
        return contacts[key]?[indexPath.row].last_name
    }
    
    func getIsFavorite(_ indexPath: IndexPath) -> Bool {
        guard indexPath.section < contacts.count else { return false }
        let key = sortingKeys[indexPath.section]
        
        guard indexPath.row < contacts[key]?.count ?? 0 else { return false }
        return contacts[key]?[indexPath.row].favorite ?? false
    }
    
    func getProfileUrl(_ indexPath: IndexPath) -> String? {
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
    
    func getSortingKeys() -> [String] {
        
        return sortingKeys
    }
    
    func getSortingKeysCount() -> Int {
        
        return sortingKeys.count
    }
}
