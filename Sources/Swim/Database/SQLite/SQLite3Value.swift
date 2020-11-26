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
        
    /// [Swim] A defined data type of this instance. This returns the same value as 'declaredSQLiteType' property.
    public var declaredType: SQLite3.DefineDataType {
        
        return declaredSQLiteType
    }
    
    /// [Swim] A actual data type of this instance. This returns the same value as 'actualSQLiteType' property.
    public var actualType: SQLite3.ActualDataType {
        
        return actualSQLiteType
    }
    
    public var isNull: Bool {
        
        switch self {
        
        case .integer(.none), .real(.none), .text(.none), .unspecified(.none):
            return true
            
        case .integer(.some), .real(.some), .text(.some), .unspecified(.some):
            return false
        }
    }

    public var integerValue: Int? {
        
        switch self {
        
        case .integer(let value):
            return value.integerValue
            
        case .unspecified(let value):
            return value?.integerValue
            
        default:
            return nil
        }
    }
    
    public var realValue: Double? {
        
        switch self {
        
        case .real(let value):
            return value.realValue
            
        case .unspecified(let value):
            return value?.realValue
            
        default:
            return nil
        }
    }

    public var textValue: String? {
        
        switch self {
        
        case .text(let value):
            return value.textValue
            
        case .unspecified(let value):
            return value?.textValue
            
        default:
            return nil
        }
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

    /// [Swim] Check the equality between `lhs` and `rhs`.
    /// This comparation is same as the SQLite's `<=>` operator.
    /// If either `lhs` or `rhs` is null, and both of them is not null, this operator returns false instead of NULL. Both of them is equal to null, returns true.
    ///
    /// - Parameters:
    ///   - lhs: The left side value for comparison.
    ///   - rhs: The right side value for comparison.
    /// - Returns: True if the both values is same, otherwise false.
    public static func <=> (lhs: Self, rhs: Self) -> Bool {
        
        guard !lhs.isNull, !rhs.isNull else {
            
            return lhs.isNull == rhs.isNull
        }

        return lhs == rhs
    }
    
    /// [Swim] Check the equality between `lhs` and `rhs`.
    /// This comparation is same as the SQLite's `==` operator.
    /// If either `lhs` or `rhs` is null, this operator returns false instead of NULL.
    ///
    /// - Parameters:
    ///   - lhs: The left side value for comparison.
    ///   - rhs: The right side value for comparison.
    /// - Returns: True if the both values is same, otherwise false.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        guard !lhs.isNull, !rhs.isNull else {
            
            return false
        }
        
        switch (lhs.actualType, rhs.actualType) {
        
        case (.integer, .integer):
            return lhs.integerValue! == rhs.integerValue!
            
        case (.real, .real):
            return lhs.realValue! == rhs.realValue!
            
        case (.text, .text):
            return lhs.textValue! == rhs.textValue!
            
        case (.integer, .real):
            return Double(lhs.integerValue!) == rhs.realValue!
            
        case (.real, .integer):
            return lhs.realValue! == Double(rhs.integerValue!)
            
        default:
            return false
        }
    }
}

extension SQLite3.Value : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        
        guard !lhs.isNull, !rhs.isNull else {
            
            return false
        }
        
        switch (lhs.actualType, rhs.actualType) {
        
        case (.integer, .integer):
            return lhs.integerValue! < rhs.integerValue!
            
        case (.real, .real):
            return lhs.realValue! < rhs.realValue!

        case (.text, .text):
            return lhs.textValue! < rhs.textValue!
            
        case (.integer, .real):
            return Double(lhs.integerValue!) < rhs.realValue!
            
        case (.real, .integer):
            return lhs.realValue! < Double(rhs.integerValue!)
            
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
    
    public var sqliteValue: Self {
        
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
            return (value?.description).map(SQLite3.quotedText) ?? "NULL"
            
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
