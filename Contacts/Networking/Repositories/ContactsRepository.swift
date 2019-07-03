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
        
        request.successCompletion = {[weak self] response in
            guard let self = self else { return }
            self.background.async {
                do {
                    var sortBlock: ((Contact, Contact) throws -> Bool)
                    sortBlock  = { $0.first_name ?? "" < $1.first_name ?? "" }
                    let object = try JSONDecoder().decode([Contact].self,
                                                          from: response.data).sorted(by: sortBlock)
                    
                    self.main.async {
                        completion(object, nil)
                        
                        if self.requests.isEmpty == false {
                            self.requests.removeLast()
                        }
                    }
                } catch let error {
                    self.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        
        request.errorCompletion = { response in
            
            completion(nil, response)
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
