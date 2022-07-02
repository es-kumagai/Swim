//
//  File.swift
//  
//  
//  Created by Tomohiro Kumagai on 2022/04/24
//  
//

/// [Swim] A boolean value for SQLite3.
public struct Boolean {
    
    public var boolValue: Bool
    
    public init(_ value: Bool) {
        
        boolValue = value
    }
}

extension Boolean {

    public static let `true` = Boolean(true)
    public static let `false` = Boolean(false)
}

extension Boolean : SQLite3ValueCompatible {
    
    public static let acceptsSQLiteNull = false
    public static let declaredSQLiteType = SQLite3.DefineDataType.integer
    public var actualSQLiteType: SQLite3.ActualDataType { .integer }
    public var sqliteValue: SQLite3.Value { .integer(integerValue) }
    
    public var integerValue: Int? { boolValue ? 1 : 0 }
    public var realValue: Double? { boolValue ? 1 : 0 }
    public var textValue: String? { boolValue ? "1" : "0" }
    public var booleanValue: Boolean? { Boolean(boolValue) }
    public var isNull: Bool { false }
    
    public init?(_ value: SQLite3.Value) {

        guard let value = value.booleanValue else {
            
            return nil
        }
        
        self = value
    }
}
