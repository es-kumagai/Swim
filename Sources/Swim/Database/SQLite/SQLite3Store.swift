//
//  SQLite3Store.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/10.
//

extension SQLite3 {
    
    public enum Store {
        
        case path(String)
        case onMemory
        case temporary
    }
}

extension SQLite3.Store {

    public var filename: String {
        
        switch self {
            
        case .path(let path):
            return path
            
        case .onMemory:
            return ":memory:"
            
        case .temporary:
            return ""
        }
    }
}
