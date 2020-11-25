//
//  SQLite3Value.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/24.
//

extension SQLite3 {
    
    /// A type that express SQLite3 data type.
    public enum Value {
        
        case unspecified(SQLite3ValueCompatible?)
        case integer(Int?)
        case real(Double?)
        case text(String?)
    }
}

extension SQLite3.Value {
    
    public init<T>(_ value: T) where T : SQLite3ValueCompatible {
        
        self = value.sqliteValue
    }
    
    public var isNull: Bool {
        
        switch self {
        
        case .integer(.none), .real(.none), .text(.none), .unspecified(.none):
            return true
            
        case .integer(.some), .real(.some), .text(.some), .unspecified(.some):
            return false
        }
    }
    
    /// [Swim] A defined data type of this instance. This returns the same value as 'declaredSQLiteType' property.
    public var declaredType: SQLite3.DefineDataType {
        
        return declaredSQLiteType
    }
    
    /// [Swim] A actual data type of this instance. This returns the same value as 'actualSQLiteType' property.
    public var actualType: SQLite3.ActualDataType {
        
        return actualSQLiteType
    }
}

extension SQLite3.Value : ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Int) {
        
        self = .integer(value)
    }
}

extension SQLite3.Value : ExpressibleByFloatLiteral {
    
    public init(floatLiteral value: Double) {
        
        self = .real(value)
    }
}

extension SQLite3.Value : ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        
        self = .text(value)
    }
}

extension SQLite3.Value : ExpressibleByNilLiteral {
    
    public init(nilLiteral: ()) {
        
        self = .unspecified(nil)
    }
}

extension SQLite3.Value : Equatable {

    public static func == (lhs: SQLite3.Value, rhs: SQLite3.Value) -> Bool {

        switch (lhs, rhs) {
        
        case let (.unspecified(nil), rhs):
            return rhs.isNull
            
        case let (lhs, .unspecified(nil)):
            return lhs.isNull
            
        case let (.unspecified(lhs?), rhs):
            return lhs.sqliteValue.description == rhs.description

        case let (lhs, .unspecified(rhs?)):
            return lhs.description == rhs.sqliteValue.description

        case let (.integer(lhs), .integer(rhs)):
            return lhs == rhs

        case let (.real(lhs), .real(rhs)):
            return lhs == rhs

        case let (.text(lhs), .text(rhs)):
            return lhs == rhs
            
        default:
            return false
        }
    }
}

extension SQLite3.Value : SQLite3ValueCompatible {
    
    /// [Swim] A defined data type of this instance. This returns the same value as 'declaredType' property.
    public static var declaredSQLiteType: SQLite3.DefineDataType { .variant }
    
    /// [Swim] A actual data type of this instance. This returns the same value as 'actualType' property.
    public static var acceptsSQLiteNull: Bool { true }
    
    public var actualSQLiteType: SQLite3.ActualDataType {
        
        switch self {
        
        case .integer(let value):
            return value.actualSQLiteType
            
        case .real(let value):
            return value.actualSQLiteType
            
        case .text(let value):
            return value.actualSQLiteType
            
        case .unspecified(let value?):
            return value.actualSQLiteType
            
        case .unspecified(nil):
            return .null
        }
    }
    
    public var sqliteValue: SQLite3.Value {
        
        return self
    }
}

extension SQLite3.Value : CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        
        case .integer(let value):
            return value?.description ?? "NULL"
            
        case .real(let value):
            return value?.description ?? "NULL"
            
        case .text(let value):
            return (value?.description).map(SQLite3.quoted) ?? "NULL"
            
        case .unspecified(let value?):
            return "\(value)"
            
        case .unspecified(nil):
            return "NULL"
        }
    }
}

extension SQLite3.Value : CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        return "\(description) (\(declaredType))"
    }
}
