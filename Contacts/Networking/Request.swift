//
//  ListRequest.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation
import Networking

protocol RequestProtocol {
    var method: HTTPMethod { get set }
    var path: String { get set }
    
    func getCompletion() -> (_ result: JSONResult) -> Void
}

class Request: RequestProtocol {
    
    var id: String = UUID().uuidString
    var path: String
    var method: HTTPMethod
    var parameters: [String: Any]?
    var successCompletion: ((Response) -> Void)!
    var errorCompletion: ((ErrorResponse) -> Void)!
    
    init(path: String,
         method: HTTPMethod) {
        
        self.path       = path
        self.method     = method
    }
    
    internal func getCompletion() -> (JSONResult) -> Void {

        return { result in
            
            switch result {
            case .success(let response):
                print("""
                    path:\(self.path)
                    response: \(String(describing: response.dictionaryBody))
                    """)
                
                let successResponse = Response(statusCode: response.statusCode,
                                               data: response.data)
                
                self.successCompletion(successResponse)
            case .failure(let response):
                
                let errorResponse = ErrorResponse(statusCode: String(response.error.code),
                                                  error: response.error.localizedDescription)
                
                DispatchQueue.main.async {
                    self.errorCompletion(errorResponse)
                }
            }
        }
    }
    
    internal func createParametersFrom<T: Encodable>(_ parameters: T) {
        do {
            let params       = try JSONEncoder().encode(parameters)
            let serialized   = try JSONSerialization.jsonObject(with: params,
                                                                options: .mutableContainers)
            let dict              = serialized as? [String: Any]
            self.parameters       = dict
            print(self.parameters ?? [:])
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
