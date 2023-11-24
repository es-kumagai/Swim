//
//  CSVColumnConvertible.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/09.
//

/// [Swim] A type that can convert from/to CSV data.
/// This protocol is able to adopted to only `Int`, `Double`, `String` and the `Optional`s.
public protocol CSVColumnConvertible {
    
    init?(csvDescription: some StringProtocol)
    var csvDescription: String { get }
}

extension CSVColumnConvertible {
        
    public static func unsafeWrite(csvDescription: some StringProtocol, to pointer: UnsafeMutableRawPointer, offset: Int = 0) -> Bool {

        guard let value = self.init(csvDescription: csvDescription) else {
            
            return false
        }

        let location = pointer + offset
        let targetPointer = location.bindMemory(to: Self.self, capacity: 1)
        
        targetPointer.pointee = value
        
        return true
    }
}

extension BinaryInteger where Self : LosslessStringConvertible {
    
    public init?(csvDescription: some StringProtocol) {
        self.init(String(csvDescription))
    }
    
    public var csvDescription: String {
        description
    }
}

extension FloatingPoint where Self : LosslessStringConvertible {
    
    public init?(csvDescription: some StringProtocol) {
        self.init(String(csvDescription))
    }
    
    public var csvDescription: String {
        description
    }
}

extension Int : CSVColumnConvertible {}
extension Int8 : CSVColumnConvertible {}
extension Int16 : CSVColumnConvertible {}
extension Int32 : CSVColumnConvertible {}
extension Int64 : CSVColumnConvertible {}
extension UInt : CSVColumnConvertible {}
extension UInt8 : CSVColumnConvertible {}
extension UInt16 : CSVColumnConvertible {}
extension UInt32 : CSVColumnConvertible {}
extension UInt64 : CSVColumnConvertible {}

extension String : CSVColumnConvertible {
    
    public init?(csvDescription: some StringProtocol) {
        self = CSV.extracted(csvDescription) ?? String(csvDescription)
    }
    
    public var csvDescription: String {
        CSV.quoted(self)
    }
}

extension Bool : CSVColumnConvertible {
    
    public init?(csvDescription: some StringProtocol) {
        
        switch csvDescription.lowercased() {
        case "true", "1", "yes", "ok":
            self = true
            
        case "false", "0", "no", "ng":
            self = false
            
        default:
            return nil
        }
    }
    
    public var csvDescription: String {
        description
    }
}

extension Double : CSVColumnConvertible {}
extension Float : CSVColumnConvertible {}

extension Optional : CSVColumnConvertible where Wrapped : CSVColumnConvertible {
    
    public init?(csvDescription: some StringProtocol) {
        
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
