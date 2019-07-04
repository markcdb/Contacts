//
//  GlobalFactory.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

class GlobalVMFactory {
    
    static func createContactListVM(repository: ContactsRepository? = nil,
                                    delegate: BaseVMDelegate) -> ContactListVM {
        let viewModel = ContactListVM(delegate: delegate,
                                      repository: repository ?? ContactsRepository())
        return viewModel
    }
    
    static func createContactDetailsVM(repository: ContactsRepository? = nil,
                                       delegate: BaseVMDelegate) -> ContactDetailsVM {
        
        let viewModel = ContactDetailsVM(delegate: delegate,
                                         repository: repository ?? ContactsRepository())
        return viewModel
    }
    
}
