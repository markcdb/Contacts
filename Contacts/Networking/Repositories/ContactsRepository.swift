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
    
    func getContacts(completion: @escaping (([Contact]?, Error?) -> ())) {
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
    
    func getContact(id: String,
                    completion: @escaping ((Contact?, Error?) -> Void)) {
        let path = Paths.contact.replacingOccurrences(of: URLParameters.id,
                                                      with: id)
        
        let request = Request(path: path,
                              method: .get)
        
        createSuccessAndFail(request,
                             completion: completion) { (contact, group) in
                                group.leave()
        }
        
        requests.append(request)
    }
}

class MockContactsRepository: ContactsRepository {
    
    public var failable: Bool = false {
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
}
