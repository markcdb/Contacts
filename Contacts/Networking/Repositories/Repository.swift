//
//  Repository.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

protocol RepositoryProtocol {
    //Screen specific request
    func request()
}

class Repository: RepositoryProtocol {
    
    var background = DispatchQueue.global(qos: .userInitiated)
    var main       = DispatchQueue.main
    var group      = DispatchGroup()
    
    var api: API?
    var requests: [Request] = [] {
        didSet {
            if requests.isEmpty == false {
                request()
            }
        }
    }
    
    init() {
        api = API(host: NetworkConfig.baseUrl)
    }
    
    internal func request() {
        // Construct the request object (ListRequest)
        guard let currRequest = requests.last else { return }
        api?.request(request: currRequest)
    }
    
    internal func createSuccessAndFail<T: Codable>(_ request: Request,
                                          completion: @escaping ((T?, Error?) -> ()),
                                          operationBlock: ((inout T, DispatchGroup) -> ())? = nil ) {
        
        request.successCompletion = {[weak self] response in
            guard let self = self else { return }
            self.background.async {
                do {
                    self.group.enter()
                    //Try to check if response is of type ErrorResponse: Codable
                    let error = try? JSONDecoder().decode(ErrorResponse.self,
                                                         from: response.data)
                    
                    if let error = error {
                        self.main.async {
                            completion(nil, error)
                        }
                        self.group.leave()
                        return
                    }
                    
                    var object = try JSONDecoder().decode(T.self,
                                                          from: response.data)
                    
                    if let block = operationBlock {
                        block(&object, self.group)
                    } else {
                        self.group.leave()
                    }
                    
                    self.group.notify(queue: self.main, execute: {
                        completion(object, nil)
                        
                        if self.requests.isEmpty == false {
                            self.requests.removeLast()
                        }
                    })
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
    }
}
