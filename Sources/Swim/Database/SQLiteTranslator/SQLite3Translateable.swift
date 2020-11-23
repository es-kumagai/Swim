//
//  SQLite3Translateable.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/23.
//

public protocol SQLite3Translateable {
    
}

extension SQLite3Translateable {
    
    public static var mirror: Mirror {
        
        let dummyData = UnsafeMutableBufferPointer<Self>.allocate(capacity: MemoryLayout<Self>.size)
        let dummyInstance = UnsafeRawBufferPointer(dummyData).load(as: Self.self)
        
        dummyData.deallocate()
        
        return Mirror(reflecting: dummyInstance)
    }
}
