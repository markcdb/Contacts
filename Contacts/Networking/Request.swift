//
//  Request.swift
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

protocol Request {
    var method: HTTPMethod { get set }
    var path: String { get set }
    
    func getCompletion() -> (_ result: JSONResult) -> Void
}
