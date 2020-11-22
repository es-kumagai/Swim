//
//  SQLite3Translateable.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/23.
//

public protocol SQLite3Translateable {
    
    static var mirror: Mirror { get }
}

extension SQLite3Translateable {
    
    public static var mirror: Mirror {
        
        let invalidData = UnsafeMutableBufferPointer<Self>.allocate(capacity: MemoryLayout<Self>.size)
        let invalidInstance = UnsafeRawBufferPointer(invalidData).load(as: Self.self)
        
        return Mirror(reflecting: invalidInstance)
    }
}
