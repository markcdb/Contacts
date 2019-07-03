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
    
    internal var networking: Networking?
    
    public var mocking: Bool {
        if ProcessInfo.processInfo.environment[Paths.testPath] != nil {
            return true
        }
        return false
    }
    
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
        
        let method      = request.method
        let path        = request.path

        let completion: (_ result: JSONResult) -> Void = request.getCompletion()
        
        print("Requesting from: \(path)")
        
        switch method {
        case .get:
            var queryString   = ""
            if let parameters = jsonRequest?.parameters {
                
                queryString   = jsonRequest != nil ? createQueryString(from: parameters) : ""
                queryString   = queryString.addingPercentEncoding(
                                withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
            }
            
            self.networking?.get("\(path)\(queryString)",
                                completion: completion)
        case .post:
            
            self.networking?.post(path,
                                  parameters: jsonRequest?.parameters,
                                  completion: completion)
        case .put:
            
            self.networking?.put(path,
                                 parameterType: .json,
                                 parameters: jsonRequest?.parameters,
                                 completion: completion)
        case .delete:

            self.networking?.delete(path,
                                    parameters: jsonRequest?.parameters,
                                    completion: completion)
        }
    }
}

class MockAPI: API {
    
    var failable: Bool?
    
    override init(host: String) {
        super.init(host: host)
    }
    
    private func createMockPathFrom(_ path: String,
                                    httpMethod: HTTPMethod) -> String {
        
        return httpMethod.rawValue + "-\(path.replacingOccurrences(of: "/", with: ""))"
    }

    override func request(jsonRequest: JSONRequest?, request: Request) {
        let method      = request.method
        let path        = request.path
        var mockPath    = createMockPathFrom(request.path,
                                             httpMethod: request.method)
        
        if failable == true {
            mockPath    = mockPath.replacingOccurrences(of: ".json",
                                                        with: "-failed.json")
        }
        
        let mockRequest                 = Request(path: path,
                                                  method: request.method)
        mockRequest.errorCompletion     = request.errorCompletion
        mockRequest.successCompletion   = request.successCompletion
        
        switch method {
        case .get:
            self.networking?.fakeGET(path,
                                     fileName: mockPath,
                                     bundle: Bundle.main)
        case .post:
            self.networking?.fakePOST(path,
                                      fileName: mockPath,
                                      bundle: Bundle.main)
        case .put:
            self.networking?.fakePUT(path,
                                     fileName: mockPath,
                                     bundle: Bundle.main)
        case .delete:
            self.networking?.fakeDELETE(path,
                                        fileName: mockPath,
                                        bundle: Bundle.main)
        }
        
        super.request(jsonRequest: jsonRequest,
                      request: request)
    }
}
