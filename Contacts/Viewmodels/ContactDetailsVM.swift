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
        
        self.viewState = .loading(nil)
        
        
    }
}
