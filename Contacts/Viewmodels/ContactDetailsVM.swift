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
    
    override var contact: Contact? {
        didSet {
            firstName = contact?.first_name
            lastName  = contact?.last_name
            mobile    = contact?.phone_number
            email     = contact?.email
        }
    }
    
    internal var detailsType: ContactDetailsType?
    
    internal var firstName: String?
    internal var lastName: String?
    internal var mobile: String?
    internal var email: String?

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
    
    internal func updateFavorite(completion: @escaping ((Error?) -> Void)) {
        contact?.favorite?.toggle()
        
        guard let con = contact else { return }
        
        repository?.editContact(newContact: con,
                                completion: {[weak self] (contact, error) in
                                    guard let self = self else { return }
                                    self.contact = contact
                                    NotificationCenter.default.post(name: Notifications.update,
                                                                    object: contact)
                                    completion(error)
        })
    }
    
    internal func createContact(completion: @escaping ((Error?) -> Void)) {
        
        let con     = Contact(id: 0,
                              first_name: firstName,
                              last_name: lastName,
                              email: email,
                              phone_number: mobile,
                              profile_pic: nil,
                              favorite: nil,
                              created_at: nil,
                              updated_at: nil)
        
        repository?.createContact(newContact: con,
                                  completion: {[weak self] (newContact, error) in
                                    guard let self = self,
                                        error == nil else {
                                            completion(error)
                                            return
                                    }
                                    
                                    self.contact = newContact
                                    NotificationCenter.default.post(name: Notifications.create,
                                                                    object: newContact)
                                    completion(nil)
        })
    }
    
    internal func editContact(contact: Contact? = nil,
                              completion: @escaping ((Error?) -> Void)) {
        
        var contact = contact ?? self.contact
        contact?.first_name     = firstName
        contact?.last_name      = lastName
        contact?.phone_number   = mobile
        contact?.email          = email
        
        guard let con = contact else { return }
        
        repository?.editContact(newContact: con,
                                completion: { [weak self] contact, error in
                                    guard let self = self,
                                        error == nil else {
                                            completion(error)
                                            return
                                    }
                                    
                                    self.contact = contact
                                    NotificationCenter.default.post(name: Notifications.update,
                                                                    object: contact)
                                    completion(nil)
        })
    }
    
    internal func deleteContact(id: Int? = nil,
                                completion: @escaping ((Error?) -> Void)) {
        
        let id = id ?? contact?.id
        
        guard let i = id else { return }
        
        repository?.deleteContact(id: i,
                                  completion: {[weak self] (_, error) in
                                    guard let self = self,
                                        error == nil else {
                                            completion(error)
                                            return
                                    }
                                    
                                    NotificationCenter.default.post(name: Notifications.delete,
                                                                    object: self.contact)
                                    completion(nil)
        })
    }
    
    internal func setTextFromTag(_ tag: Int,
                                 text: String) {
        switch tag {
        case 0:
            firstName = text
        case 1:
            lastName = text
        case 2:
            mobile = text
        case 3:
            email = text
        default:
            break
        }
    }
    
    internal func validateEntries() -> String? {
        var string: String? = nil
        
        if firstName?.containsANumber() == true ||
            firstName?.containsEmoji == true ||
            firstName?.containsOnlyValidCharacters() == false {
            string = Strings.invalidFirstName
            return string
        }
        
        if lastName?.containsANumber() == true ||
            lastName?.containsEmoji == true ||
            lastName?.containsOnlyValidCharacters() == false {
            string = Strings.invalidLastName
            return string
        }
        
        if  email == nil ||
            email?.isEmpty == false,
            email?.isValidEmail() == false {
            string = Strings.invalidEmail
            return string
        }
        
        return string
    }
    
    internal func getTextFromTag(_ tag: Int) -> String {
        switch tag {
        case 0:
            return firstName ?? ""
        case 1:
            return lastName ?? ""
        case 2:
            return mobile ?? ""
        case 3:
            return email ?? ""
        default:
            return ""
        }
    }
}
