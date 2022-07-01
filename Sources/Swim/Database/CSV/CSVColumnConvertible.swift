//
//  CSVColumnConvertible.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/09.
//

/// [Swim] A type that can convert from/to CSV data.
/// This protocol is able to adopted to only `Int`, `Double`, `String` and the `Optional`s.
public protocol CSVColumnConvertible {
    
    init?(csvDescription: String)
    var csvDescription: String { get }
}

extension CSVColumnConvertible {
        
    public static func unsafeWrite(csvDescription: String, to pointer: UnsafeMutableRawPointer) -> Bool {

        guard let value = self.init(csvDescription: csvDescription) else {
            
            return false
        }

        pointer.storeBytes(of: value, as: self)
        
        return true
    }
}

extension Int : CSVColumnConvertible {
    
    public init?(csvDescription: String) {
        
        self.init(csvDescription)
    }
    
    public var csvDescription: String {
        
        return description
    }
}

extension String : CSVColumnConvertible {
    
    public init?(csvDescription: String) {
        
        self = CSV.extracted(csvDescription) ?? csvDescription
    }
    
    public var csvDescription: String {
        
        return CSV.quoted(self)
    }
}

extension Double : CSVColumnConvertible {
    
    public init?(csvDescription: String) {
        
        self.init(csvDescription)
    }
    
    public var csvDescription: String {
        
        return description
    }
}

extension Optional : CSVColumnConvertible where Wrapped : CSVColumnConvertible {
    
    public init?(csvDescription: String) {
        
        if csvDescription.isEmpty {
            
            self = .none
        }
        else {
            
            self = Wrapped.init(csvDescription: csvDescription)
        }
    }
    
    public var csvDescription: String {
        
        switch self {
        
        case .some(let value):
            return value.csvDescription
            
        case .none:
            return ""
        }
    }
}
