//
//  LocationRepository.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

class ContactsRepository: Repository {
    
    // MARK: - Init
    override init() {
        super.init()
    }
    
    internal func getContacts(completion: @escaping (([Contact]?, Error?) -> ())) {
        let path = Paths.contacts
        
        let request = Request(path: path,
                              method: .get)
        
        createSuccessAndFail(request,
                             completion: completion) { (contacts, group) in
                                var sortBlock: ((Contact, Contact) throws -> Bool)
                                sortBlock  = { $0.first_name ?? "" < $1.first_name ?? "" }
                                
                                do {
                                    contacts = try contacts.sorted(by: sortBlock)
                                } catch let error {
                                    self.main.async {
                                        completion(nil, error)
                                    }
                                }
                                
                                group.leave()
        }
        
        requests.append(request)
    }
    
    internal func getContact(id: Int,
                    completion: @escaping ((Contact?, Error?) -> Void)) {
        let path = Paths.contact.replacingOccurrences(of: URLParameters.id,
                                                      with: String(id))
        
        let request = Request(path: path,
                              method: .get)
        
        createSuccessAndFail(request,
                             completion: completion)
        
        requests.append(request)
    }
    
    internal func editContact(newContact: Contact,
                     completion: @escaping ((Contact?, Error?) -> Void)) {
        let path = Paths.contact.replacingOccurrences(of: URLParameters.id,
                                                      with: String(newContact.id ?? 0))
        
        let request = Request(path: path,
                              method: .put)
        
        request.createParametersFrom(newContact)
        
        createSuccessAndFail(request,
                             completion: completion)
        
        requests.append(request)
    }
    
    internal func createContact(newContact: Contact,
                       completion: @escaping ((Contact?, Error?) -> Void)) {
    
        let path = Paths.contacts
        
        let request = Request(path: path,
                              method: .post)
        
        request.createParametersFrom(newContact)
        
        createSuccessAndFail(request,
                             completion: completion)
        
        requests.append(request)
    }
    
    internal func deleteContact(id: Int,
                                completion: @escaping ((Contact?, Error?) -> Void)) {
        
        let path = Paths.contact.replacingOccurrences(of: URLParameters.id,
                                                      with: String(id))
        
        let request = Request(path: path,
                              method: .delete)
                
        createSuccessAndFail(request,
                             completion: completion)
        
        requests.append(request)
    }
}

class MockContactsRepository: ContactsRepository {
    
    internal var failable: Bool = false {
        didSet {
            (api as? MockAPI)?.failable = failable
        }
    }
    
    override init() {
        super.init()
        api = MockAPI(host: NetworkConfig.baseUrl)
    }
    
    override func getContacts(completion: @escaping (([Contact]?, Error?) -> ())) {
        super.getContacts(completion: completion)
    }
    
    override func getContact(id: Int,
                             completion: @escaping ((Contact?, Error?) -> Void)) {
        super.getContact(id: id,
                         completion: completion)
    }
    
    override func editContact(newContact: Contact,
                              completion: @escaping ((Contact?, Error?) -> Void)) {
        super.editContact(newContact: newContact,
                          completion: completion)
    }
    
    override func createContact(newContact: Contact,
                                completion: @escaping ((Contact?, Error?) -> Void)) {
        super.createContact(newContact: newContact,
                            completion: completion)
    }
    
    override func deleteContact(id: Int,
                                completion: @escaping ((Contact?, Error?) -> Void)) {
        super.deleteContact(id: id,
                            completion: completion)
    }
}
