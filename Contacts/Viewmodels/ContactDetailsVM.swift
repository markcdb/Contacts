//
//  ContactDetailsVM.swift
//  Contacts
//
//  Created by Mark Christian Buot on 04/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

internal enum ContactDetailsType {
    case create
    case edit
    case view
}

class ContactDetailsVM: BaseContactVM {
    
    internal var detailsType: ContactDetailsType?
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
    
    internal func createContact(contact: Contact,
                       completion: @escaping ((Error?) -> Void)) {
        
        repository?.createContact(newContact: contact,
                                  completion: { [weak self] (newContact, error) in
                                    guard let self = self,
                                        error == nil else {
                                            completion(error)
                                            return
                                    }
                                    
                                    self.contact = newContact
                                    completion(nil)
                                    
                                    NotificationCenter.default.post(name: Notifications.create,
                                                                    object: contact)
        })
    }
    
    internal func editContact(contact: Contact,
                              completion: @escaping ((Error?) -> Void)) {
        
        
        repository?.editContact(newContact: contact,
                                completion: { [weak self] contact, error in
                                    guard let self = self,
                                        error == nil else {
                                            completion(error)
                                            return
                                    }
                                    
                                    self.contact = contact
                                    completion(nil)
                                    
                                    NotificationCenter.default.post(name: Notifications.update,
                                                                    object: contact)
                                    
        })
    }
    
    internal func deleteContact(contact: Contact,
                       completion: @escaping ((Error?) -> Void)) {
        
        repository?.deleteContact(contact: contact,
                                  completion: {[weak self] (deletedContact, error) in
                                    guard let _ = self,
                                        error == nil else {
                                            completion(error)
                                            return
                                    }
                                    
                                    completion(nil)
                                    
                                    NotificationCenter.default.post(name: Notifications.delete,
                                                                    object: contact)
        })
    }
}
