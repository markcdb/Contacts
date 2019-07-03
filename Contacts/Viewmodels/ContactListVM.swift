//
//  ContactListVM.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

class ContactListVM: BaseVM {
    
    private var repository: ContactsRepository?
    private var contacts: [Contact] = []
    
    init(delegate: BaseVMDelegate,
         repository: ContactsRepository) {
        super.init(delegate: delegate)
        
        self.repository = repository
    }
    
    override func request() {
        super.request()
        
        repository?.getContacts(completion: {[weak self] (contacts, error) in
            guard let self = self else { return }
            
            guard error == nil,
                let contacts = contacts else {
                    
                let errorMsg = error?.localizedDescription ?? ""
                self.viewState = .error(errorMsg)

                return
            }
            
            self.viewState = .success(nil)
            self.contacts  = contacts
        })
    }
}
