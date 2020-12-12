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

    var integerValue: Int? { get }
    var realValue: Double? { get }
    var textValue: String? { get }
    var isNull: Bool { get }
    
    init?(_ value: SQLite3.Value)
}

extension Int : SQLite3ValueCompatible {

    public static var acceptsSQLiteNull: Bool { false }
    public static var declaredSQLiteType: SQLite3.DefineDataType { .integer }
    public var actualSQLiteType: SQLite3.ActualDataType { .integer }
    public var sqliteValue: SQLite3.Value { .integer(self) }
    
    public var integerValue: Int? { self }
    public var realValue: Double? { nil }
    public var textValue: String? { nil }
    public var isNull: Bool { false }

    public init?(_ value: SQLite3.Value) {
        
        guard let value = value.integerValue else {
            
            return nil
        }
        
        self = value
    }
}

extension Double : SQLite3ValueCompatible {
    
    public static var acceptsSQLiteNull: Bool { false }
    public static var declaredSQLiteType: SQLite3.DefineDataType { .real }
    public var actualSQLiteType: SQLite3.ActualDataType { .real }
    public var sqliteValue: SQLite3.Value { .real(self) }
    
    public var integerValue: Int? { nil }
    public var realValue: Double? { self }
    public var textValue: String? { nil }
    public var isNull: Bool { false }

    public init?(_ value: SQLite3.Value) {
        
        guard let value = value.realValue else {
            
            return nil
        }
        
        self = value
    }
}

extension String : SQLite3ValueCompatible {
    
    public static var acceptsSQLiteNull: Bool { false }
    public static var declaredSQLiteType: SQLite3.DefineDataType { .text }
    public var actualSQLiteType: SQLite3.ActualDataType { .text }
    public var sqliteValue: SQLite3.Value { .text(self) }
    
    public var integerValue: Int? { nil }
    public var realValue: Double? { nil }
    public var textValue: String? { self }
    public var isNull: Bool { false }

    public init?(_ value: SQLite3.Value) {
        
        guard let value = value.textValue else {
            
            return nil
        }
        
        self = value
    }
}

extension Optional : SQLite3ValueCompatible where Wrapped : SQLite3ValueCompatible {
    
    public static var acceptsSQLiteNull: Bool { true }
    public static var declaredSQLiteType: SQLite3.DefineDataType { Wrapped.declaredSQLiteType }
    public var actualSQLiteType: SQLite3.ActualDataType { self?.actualSQLiteType ?? .null }
        
    public var integerValue: Int? { self?.integerValue }
    public var realValue: Double? { self?.realValue }
    public var textValue: String? { self?.textValue }
    public var isNull: Bool { self == nil }

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

    public init?(_ value: SQLite3.Value) {
        
        switch value {
        
        case .integer where Wrapped.declaredSQLiteType == .integer:
            self = Wrapped(value)
            
        case .real where Wrapped.declaredSQLiteType == .real:
            self = Wrapped(value)
            
        case .text where Wrapped.declaredSQLiteType == .text:
            self = Wrapped(value)
            
        case .unspecified(.none):
            self = .none
            
        case .unspecified(.some(let value)):
            self = Wrapped(value.sqliteValue)
            
        default:
            return nil
        }
    }
}

extension SQLite3ValueCompatible {
    
    public var acceptsSQLiteNull: Bool { Self.acceptsSQLiteNull }
    public var declaredSQLiteType: SQLite3.DefineDataType { Self.declaredSQLiteType }
}
