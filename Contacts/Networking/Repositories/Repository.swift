//
//  Repository.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

protocol RepositoryProtocol {
    
    associatedtype T: Codable

    func getList(params: T?,
                 completion: @escaping (([T]?, Error?) -> ()))
    
    func get<U>(params: U?,
                completion: @escaping ((T?, Error?) -> ()))
    
    func create(params: T?,
                completion: @escaping ((T?, Error?) -> ()))
    
    func edit(params: T?,
              completion: @escaping ((T?, Error?) -> ()))
    
    func delete<U>(params: U?,
                   completion: @escaping ((T?, Error?) -> ()))
    
    func retry()
}

protocol MainRepositoryProtocol {
    //Screen specific request
    func request(_ req: Request?)
}

class Repository<T: Codable>: MainRepositoryProtocol, RepositoryProtocol {
   
    typealias T = T
    typealias ArrayC = (([T]?, Error?) -> ())
    typealias SingleC = ((T?, Error?) -> ())
    
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

    func getList(params: T?,
                 completion: @escaping ArrayC) {}
    
    func get<U>(params: U?,
                completion: @escaping SingleC) {}
    
    func create(params: T?,
                completion: @escaping SingleC) {}
    
    func edit(params: T?,
              completion: @escaping SingleC) {}
    
    func delete<U>(params: U?,
                   completion: @escaping SingleC) {}
    
    func retry() {
        for req in requests {
            request(req)
        }
    }

    internal func request(_ req: Request? = nil) {
        // Construct the request object (ListRequest)
        var request: Request?
        
        if let req = req {
            request = req
        } else {
            request = requests.last
        }
        
        api?.request(request: request)
    }
    
    internal func createSuccessAndFail<T: Codable>(_ request: Request,
                                                   completion: @escaping ((T?, Error?) -> ()),
                                                   operationBlock: ((inout T, DispatchGroup) -> ())? = nil ) {
        
        request.successCompletion = {[weak self] response in
            guard let self = self else { return }
            self.background.async {
                if response.data.isEmpty {
                    self.main.async {
                        completion(nil, nil)
                    }
                    return
                }
                
                do {
                    self.group.enter()
                    //Try to check if response is of type ErrorResponse: Codable
                    let errorCodable = try? JSONDecoder().decode(ErrorCodable.self,
                                                                 from: response.data)
                    
                    if let errorCodable = errorCodable {
                        let error       = ErrorResponse(errorCodable: errorCodable)
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
                    
                    if let index = self.requests.firstIndex(where: { $0.id == request.id }) {
                        self.requests.remove(at: index)
                    }
                    
                    self.group.notify(queue: self.main, execute: {
                        completion(object, nil)
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
