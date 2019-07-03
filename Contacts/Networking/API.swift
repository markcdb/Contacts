//
//  API.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation
import Networking

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

class API {

    var mocking: Bool {
        if ProcessInfo.processInfo.environment[Paths.testPath] != nil {
            return true
        }
        return false
    }
    
    private var networking: Networking?
    public var host: String
    
    init(host: String) {
        
        self.host = host
        
        self.networking = Networking(baseURL: host)
    }
    
    private func createQueryString(from parameters: [String: Any]) -> String {
        var queryString = ""
        
        if parameters.keys.count > 0 {
            queryString.append("?")
            let sortedKeys = parameters.keys.sorted()
            for key in sortedKeys {
                queryString.append("\(key)=\(parameters[key] ?? "")")
                if sortedKeys.last != key {
                    queryString.append("&")
                }
            }
        }
        
        return queryString
    }
    
    public func request(jsonRequest: JSONRequest? = nil,
                              request: Request) {
        
        let method  = request.method
        var path    = request.path
        
        let completion: (_ result: JSONResult) -> Void = request.getCompletion()
        
        print("Requesting from: \(path)")
        
        if mocking {
            path = method.rawValue + "-\(path.replacingOccurrences(of: "/", with: ""))"
        }
        
        switch method {
        case .get:
            var queryString   = ""
            if let parameters = jsonRequest?.parameters {
                
                queryString   = jsonRequest != nil ? createQueryString(from: parameters) : ""
                queryString   = queryString.addingPercentEncoding(
                                withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
            }
            
            if mocking {
                self.networking?.fakeGET(path,
                                         fileName: path,
                                         bundle: Bundle.main)
            }
            
            self.networking?.get("\(path)\(queryString)",
                                completion: completion)
        case .post:
            if mocking {
                self.networking?.fakePOST(path,
                                          fileName: path,
                                          bundle: Bundle.main)
            }
            
            self.networking?.post(path,
                                  parameters: jsonRequest?.parameters,
                                  completion: completion)
        case .put:
            if mocking {
                self.networking?.fakePUT(path,
                                         fileName: path,
                                         bundle: Bundle.main)
            }
            
            self.networking?.put(path,
                                 parameterType: .json,
                                 parameters: jsonRequest?.parameters,
                                 completion: completion)
        case .delete:
            if mocking {
                self.networking?.fakeDELETE(path, fileName: path, bundle: Bundle.main)
            }
            
            self.networking?.delete(path,
                                    parameters: jsonRequest?.parameters,
                                    completion: completion)
        }
    }
}
