//
//  ListRequest.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation
import Networking

protocol JSONRequest {
    
    var parameters: [String: Any] { get }
}

protocol RequestProtocol {
    var method: HTTPMethod { get set }
    var path: String { get set }
    
    func getCompletion() -> (_ result: JSONResult) -> Void
}

class Request: RequestProtocol {
    
    var path: String
    var method: HTTPMethod
    var successCompletion: ((Response) -> Void)!
    var errorCompletion: ((ErrorResponse) -> Void)!
    
    init(path: String,
         method: HTTPMethod) {
        
        self.path = path
        self.method = method
    }
    
    func getCompletion() -> (JSONResult) -> Void {

        return { result in
            
            switch result {
            case .success(let response):
                print("""
                    path:\(self.path)
                    response: \(String(describing: response.fullResponse))
                    """)
                
                let successResponse = Response(status: response.statusCode,
                                               data: response.data)
                
                self.successCompletion(successResponse)
            case .failure(let response):
                
                let errorResponse = ErrorResponse(status: response.error.code,
                                                  errorDescription: response.error.localizedDescription)
                
                DispatchQueue.main.async {
                    self.errorCompletion(errorResponse)
                }
            }
        }
    }
}
