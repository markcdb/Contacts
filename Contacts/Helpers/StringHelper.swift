//
//  StringHelper.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

extension String {
    
    func toDate() -> Date? {
        if self == "" { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.date(from: self)
    }
    
    func index(of string: String) -> Int? {
        guard let index = range(of: string)?.lowerBound else { return nil }
        return distance(from: startIndex, to: index)
    }
    
    func length() -> Int? {
        return distance(from: startIndex, to: endIndex)
    }
    
    func toURL() -> URL? {
        return URL(string: self)
    }
    
    func urlFromString() -> URL? {
        let type     = NSTextCheckingResult.CheckingType.link.rawValue
        
        let detector = try! NSDataDetector(types: type)
        
        var toUrl: URL?
        
        detector.enumerateMatches(in: self,
                                  options: [],
                                  range: NSMakeRange(0, self.count)) { result, _, _ in
            
            guard let result = result,
                let url = result.url  else { return }
            
            toUrl = url
        }
        
        return toUrl ?? nil
    }

    static func generateAlphabetArray() -> [String] {
        let aScalars = "a".unicodeScalars
        let aCode = aScalars[aScalars.startIndex].value
        
        var letters: [String] = (0..<26).map {
            i in String(UnicodeScalar(aCode + i)!).uppercased()
        }
        
        letters.append("#")
        
        return letters
    }
}
