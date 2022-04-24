//
//  DateTime.swift
//  
//  
//  Created by Tomohiro Kumagai on 2022/04/24
//  
//

/// [Swim] A date time for SQLite3 expressed by UTC.
public struct DateTime {
    
    public private(set) var rawValue: String
}

extension DateTime : SQLite3ValueCompatible {
    
    public static let acceptsSQLiteNull = false
    public static let declaredSQLiteType = SQLite3.DefineDataType.text
    public var actualSQLiteType: SQLite3.ActualDataType { .text }
    public var sqliteValue: SQLite3.Value { .text(rawValue) }
    
    public var integerValue: Int? { nil }
    public var realValue: Double? { nil }
    public var textValue: String? { rawValue }
    public var booleanValue: Boolean? { nil }
    public var isNull: Bool { false }
    
    public init?(_ value: SQLite3.Value) {

        guard let text = value.textValue else {
            
            return nil
        }

        self.init(rawValue: text)
    }
}

