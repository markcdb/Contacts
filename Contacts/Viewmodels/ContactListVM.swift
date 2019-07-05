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
        self.setupCUD()
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
    
    internal func setupCUD() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(create(notification:)),
                                               name: Notifications.create,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(update(notification:)),
                                               name: Notifications.update,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(delete(notification:)),
                                               name: Notifications.delete,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Custom methods
extension ContactListVM {

    @objc internal func create(notification: Notification) {
        print("Notified CREATE!!")
        guard let contact = notification.object as? Contact,
              let first   = contact.first_name?.first else { return }
        
        let string        = String(first).uppercased()
        
        if self.contacts[string]?.contains(where: { $0.id == contact.id }) == true {
            return
        }
        
        print("Added contact with ID: \(contact.id ?? 0)")
        if self.contacts[string] == nil {
            self.contacts[string] = [contact]
        } else {
            self.contacts[string]?.insert(contact,
                                          at: 0)
        }
       
        self.viewState = .success(nil)
    }
    
    @objc internal func update(notification: Notification) {
        guard let contact = notification.object as? Contact else { return }
        
        let string      = self.contacts.compactMap { (key, contacts) -> String? in
            if contacts.contains(where: { $0.id == contact.id }) {
                return key
            }
            
            return nil
        }.first ?? ""
        
        if let index    = self.contacts[string]?.firstIndex(where: { $0.id == contact.id }),
            index < self.contacts[string]?.count ?? 0 {
            self.contacts[string]?[index] = contact
            self.viewState = .success(nil)
        }
    }
    
    @objc internal func delete(notification: Notification) {
        guard let contact = notification.object as? Contact else { return }
        
        let string      = self.contacts.compactMap { (key, contacts) -> String? in
            if contacts.contains(where: { $0.id == contact.id }) {
                return key
            }
            
            return nil
        }.first ?? ""

        if let index    = self.contacts[string]?.firstIndex(where: { $0.id == contact.id }),
            index < self.contacts[string]?.count ??  0 {
            self.contacts[string]?.remove(at: index)
            self.viewState = .success(nil)
        }
    }
}
