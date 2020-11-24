//
//  SQLite3Value.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/24.
//

public enum SQLite3Value {

    case unspecified(SQLite3ValueCompatible?)
    case integer(Int?)
    case real(Double?)
    case text(String?)
}

extension SQLite3Value {

    public init<Value>(_ value: Value) where Value : SQLite3ValueCompatible {
        
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

extension SQLite3Value : SQLite3Translateable {
}

extension SQLite3Value : SQLite3ValueCompatible {

    public static var declaredSQLiteType: SQLite3.DefineDataType { .variant }
    public static var acceptsSQLiteNull: Bool { true }

    /// [Swim] A defined data type of this instance. This returns the same value as 'declaredType' property.
    public var actualSQLiteType: SQLite3.ActualDataType {
    
        switch self {
        
        case .integer:
            return .integer
            
        case .real:
            return .real
            
        case .text:
            return .text
            
        case .unspecified(let value):
            return value?.actualSQLiteType ?? .null
        }
    }
    
    /// [Swim] A actual data type of this instance. This returns the same value as 'actualType' property.
    public var sqliteDescription: String {
        
        switch self{
        
        case .integer(let value):
            return value.sqliteDescription
            
        case .real(let value):
            return value.sqliteDescription
            
        case .text(let value):
            return value.sqliteDescription
            
        case .unspecified(let value):
            return value?.sqliteDescription ?? ""
        }
    }
    
    public var sqliteValue: SQLite3Value {
        
        return self
    }
}

extension SQLite3Value : CustomStringConvertible {

    public var description: String {
        
        return sqliteDescription
    }
}
