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

extension Int : CSVColumnConvertible {
    
    public init?(csvDescription: some StringProtocol) {
        
        self.init(csvDescription)
    }
    
    public var csvDescription: String {
        
        return description
    }
}

extension String : CSVColumnConvertible {
    
    public init?(csvDescription: some StringProtocol) {
        
        self = CSV.extracted(csvDescription) ?? String(csvDescription)
    }
    
    public var csvDescription: String {
        
        return CSV.quoted(self)
    }
}

extension Double : CSVColumnConvertible {
    
    public init?(csvDescription: some StringProtocol) {
        
        self.init(csvDescription)
    }
    
    public var csvDescription: String {
        
        return description
    }
}

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
