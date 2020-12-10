//
//  CSVColumnConvertible.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/09.
//

/// [Swim] A type that can convert from/to CSV data.
/// This protocol is able to adopted to only `Int`, `Double`, `String` and the `Optional`s.
public protocol CSVColumnConvertible {
    
    static var csvDataType: CSV.DataType { get }
    static var csvNullable: Bool { get }
    
    init?(csvDescription: String?)
    
    var csvDescription: String { get }
}

extension CSVColumnConvertible where Self : LosslessStringConvertible {
    
    public init?(csvDescription: String?) {
        
        guard let csvDescription = csvDescription else {
            
            return nil
        }

        self.init(csvDescription)
    }
    
    public var csvDescription: String {
        
        return description
    }
}

extension Int : CSVColumnConvertible {
    
    public static var csvDataType: CSV.DataType {
        
        return .integer
    }
    
    public static var csvNullable: Bool {
        
        return false
    }
}

extension String : CSVColumnConvertible {
    
    public static var csvDataType: CSV.DataType {
        
        return .string
    }
    
    public static var csvNullable: Bool {
        
        return false
    }
    
    public init?(csvDescription: String?) {
        
        guard let csvDescription = csvDescription else {
            
            return nil
        }
        
        self = CSV.extracted(csvDescription)
    }
    
    public var csvDescription: String {
        
        return CSV.quoted(self)
    }
}

extension Double : CSVColumnConvertible {
    
    public static var csvDataType: CSV.DataType {
        
        return .floatingPoint
    }
    
    public static var csvNullable: Bool {
        
        return false
    }
}

extension Optional : CSVColumnConvertible where Wrapped : CSVColumnConvertible {
    
    public static var csvDataType: CSV.DataType {
        
        return Wrapped.csvDataType
    }
    
    public static var csvNullable: Bool {
        
        return true
    }
    
    public init?(csvDescription: String?) {
        
        switch csvDescription {
            
        case .none:
            self = .none
        
        case .some(let value):
            self = Wrapped.init(csvDescription: value)
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
