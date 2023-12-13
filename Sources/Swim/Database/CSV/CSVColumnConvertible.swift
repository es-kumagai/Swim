//
//  CSVColumnConvertible.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/09.
//


/// [Swim] A type that can convert from/to CSV data.
/// This protocol is able to adopted to only `Int`, `Double`, `String` and the `Optional`s.
public protocol CSVColumnConvertible {

    init?(csvDescription: some StringProtocol, using csv: CSV)
    func csvDescription(with csv: CSV) -> String
}

extension CSVColumnConvertible {
        
    public static func unsafeWrite(csvDescription: some StringProtocol, to pointer: UnsafeMutableRawPointer, offset: Int = 0, csv: CSV = .standard) -> Bool {

        guard let value = self.init(csvDescription: csvDescription, using: csv) else {
            
            return false
        }

        let location = pointer + offset
        let targetPointer = location.bindMemory(to: Self.self, capacity: 1)
        
        targetPointer.pointee = value
        
        return true
    }
}

extension BinaryInteger where Self : LosslessStringConvertible {
    
    public init?(csvDescription: some StringProtocol, using csv: CSV = .standard) {
        self.init(String(csvDescription))
    }
    
    public func csvDescription(with csv: CSV = .standard) -> String {
        description
    }
}

extension FloatingPoint where Self : LosslessStringConvertible {
    
    public init?(csvDescription: some StringProtocol, using csv: CSV = .standard) {
        self.init(String(csvDescription))
    }
    
    public func csvDescription(with csv: CSV = .standard) -> String {
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
    
    public init?(csvDescription: some StringProtocol, using csv: CSV = .standard) {
        self = csv.extracted(csvDescription) ?? String(csvDescription)
    }
    
    public func csvDescription(with csv: CSV = .standard) -> String {
        csv.quoted(self)
    }
}

extension Bool : CSVColumnConvertible {
    
    public init?(csvDescription: some StringProtocol, using csv: CSV = .standard) {
        
        switch csvDescription.lowercased() {
        case "true", "1", "yes", "ok":
            self = true
            
        case "false", "0", "no", "ng":
            self = false
            
        default:
            return nil
        }
    }
    
    public func csvDescription(with csv: CSV = .standard) -> String {
        description
    }
}

extension Double : CSVColumnConvertible {}
extension Float : CSVColumnConvertible {}

extension Optional : CSVColumnConvertible where Wrapped : CSVColumnConvertible {
    
    public init?(csvDescription: some StringProtocol, using csv: CSV = .standard) {
        
        if csvDescription.isEmpty {
            
            self = .none
        }
        else {
            
            self = Wrapped.init(csvDescription: csvDescription, using: csv)
        }
    }
    
    public func csvDescription(with csv: CSV = .standard) -> String {
        
        switch self {
        
        case .some(let value):
            return value.csvDescription(with: csv)
            
        case .none:
            return ""
        }
    }
}
