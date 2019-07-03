//
//  ContactListVM.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

class ContactListVM: BaseContactsVM {
    
    private var repository: ContactsRepository?
    
    init(delegate: BaseVMDelegate,
         repository: ContactsRepository) {
        super.init(delegate: delegate)
        
        self.repository = repository
    }
    
    override func request() {
        super.request()
        
        self.viewState = .loading(nil)
        
        repository?.getContacts(completion: {[weak self] (contacts, error) in
            guard let self = self else { return }
            
            guard error == nil,
                let contacts = contacts else {
                    
                let errorMsg = error?.localizedDescription ?? ""
                self.viewState = .error(errorMsg)

                return
            }
            
            self.sortingKeys = contacts.compactMap({ contact -> String? in
                guard let first = contact.first_name?.first else { return nil }
                let string = String(first).uppercased()
                return string
            }).removingDuplicates().sorted(by: { $0 < $1 })
            
            self.sortingKeys.forEach({ key in
                self.contacts[key] = contacts.filter({ contact -> Bool in
                    guard let first = contact.first_name?.first else { return false }
                    let string = String(first)
                    return string == key
                })
            })
            
            self.viewState = .success(nil)
        })
    }
}
