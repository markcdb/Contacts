//
//  ContactDetailsVM.swift
//  Contacts
//
//  Created by Mark Christian Buot on 04/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

class ContactDetailsVM: BaseContactVM {
    
    private var repository: ContactsRepository?
    
    init(delegate: BaseVMDelegate,
         repository: ContactsRepository) {
        super.init(delegate: delegate)
        
        self.repository = repository
    }
    
    override func request() {
        super.request()
        
        guard let contact = contact else {
            self.viewState = .error(nil)
            return
        }
        
        self.viewState = .loading(nil)
        
        repository?.getContact(id: contact.id ?? 0,
                               completion: {[weak self] (contact, error) in
                                guard let self = self else { return }
                                
                                guard error == nil,
                                    let contact = contact else {
                                        
                                        let errorMsg = error?.localizedDescription ?? ""
                                        self.viewState = .error(errorMsg)
                                        
                                        return
                                }
                                
                                self.contact = contact
                                self.viewState = .success(nil)
        })
    }
}
