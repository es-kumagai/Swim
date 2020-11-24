//
//  SQLite3ValueCompatible.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/24.
//

/// [Swim] A type that compatible with SQLite3.
public protocol SQLite3ValueCompatible {
 
    static var acceptsSQLiteNull: Bool { get }
    static var declaredSQLiteType: SQLite3.DefineDataType { get }
    var actualSQLiteType: SQLite3.ActualDataType { get }
    var sqliteValue: SQLite3.Value { get }
}

extension Int : SQLite3ValueCompatible {

    public static var acceptsSQLiteNull: Bool { false }
    public static var declaredSQLiteType: SQLite3.DefineDataType { .integer }
    public var actualSQLiteType: SQLite3.ActualDataType { .integer }
    public var sqliteValue: SQLite3.Value { .integer(self) }
}

extension Double : SQLite3ValueCompatible {
    
    public static var acceptsSQLiteNull: Bool { false }
    public static var declaredSQLiteType: SQLite3.DefineDataType { .real }
    public var actualSQLiteType: SQLite3.ActualDataType { .real }
    public var sqliteValue: SQLite3.Value { .real(self) }
}

extension String : SQLite3ValueCompatible {
    
    public static var acceptsSQLiteNull: Bool { false }
    public static var declaredSQLiteType: SQLite3.DefineDataType { .text }
    public var actualSQLiteType: SQLite3.ActualDataType { .text }
    public var sqliteValue: SQLite3.Value { .text(self) }
}

extension Optional : SQLite3ValueCompatible where Wrapped : SQLite3ValueCompatible {
    
    public static var acceptsSQLiteNull: Bool { true }
    public static var declaredSQLiteType: SQLite3.DefineDataType { Wrapped.declaredSQLiteType }
    public var actualSQLiteType: SQLite3.ActualDataType { self?.actualSQLiteType ?? .null }
    
    public var sqliteValue: SQLite3.Value {
        
        if let value = self?.sqliteValue {
        
            return value
        }
        else {

            switch declaredSQLiteType {
            
            case .variant:
                return .unspecified(nil)
                
            case .integer:
                return .integer(nil)
                
            case .real:
                return .real(nil)
                
            case .text:
                return .text(nil)
            }
        }
    }
}

extension SQLite3ValueCompatible {
    
    public var acceptsSQLiteNull: Bool { Self.acceptsSQLiteNull }
    public var declaredSQLiteType: SQLite3.DefineDataType { Self.declaredSQLiteType }
}
