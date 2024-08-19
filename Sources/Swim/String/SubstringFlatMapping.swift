//
//  SubstringFlatMapping.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/08/19
//  
//

public extension Substring? {
    
    func map<Result>(_ transform: (String) throws -> Result) rethrows -> Result? {
       try map(String.init(_:)).map(transform)
    }

    func flatMap<Result>(_ transform: (String) throws -> Result?) rethrows -> Result? {
       try map(String.init(_:)).flatMap(transform)
    }
}
