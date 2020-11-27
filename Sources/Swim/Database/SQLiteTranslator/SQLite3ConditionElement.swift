//
//  SQLite3Condition.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/24.
//

extension SQLite3 {

    public enum ConditionElement<Target> where Target : SQLite3Translateable {
        
        public typealias Path = PartialKeyPath<Target>
        
        case equal(Path, Value)
        case notEqual(Path, Value)
        case equalConsiderNull(Path, Value)
        case lessOrEqual(Path, Value)
        case lessThan(Path, Value)
        case greaterOrEqual(Path, Value)
        case greaterThan(Path, Value)
        case between(Path, Value, Value)
        case notBetween(Path, Value, Value)
        case isNull(Path)
        case isNotNull(Path)
        case `in`(Path, [Value])
        case notIn(Path, [Value])
        case like(Path, String)
        case notLike(Path, String)
        case regularExpression(Path, String, caseSensitive: Bool)
        case rawSQL(String)
    }
}

extension SQLite3.ConditionElement : CustomDebugStringConvertible {

    public var debugDescription: String {
        
        return sql
    }
}

extension SQLite3.ConditionElement {
    
    @SpaceSeparatedList
    public var sql: String {
        
        switch self {
        
        case let .equal(keyPath, value):
            Target.sqliteField(of: keyPath).quotedFieldName
            "="
            value.description

        case let .notEqual(keyPath, value):
            Target.sqliteField(of: keyPath).quotedFieldName
            "!="
            value.description
            
        case let .equalConsiderNull(keyPath, value):
            Target.sqliteField(of: keyPath).quotedFieldName
            "<=>"
            value.description

        case let .lessOrEqual(keyPath, value):
            Target.sqliteField(of: keyPath).quotedFieldName
            "<="
            value.description
            
        case let .lessThan(keyPath, value):
            Target.sqliteField(of: keyPath).quotedFieldName
            "<"
            value.description
            
        case let .greaterOrEqual(keyPath, value):
            Target.sqliteField(of: keyPath).quotedFieldName
            ">="
            value.description
            
        case let .greaterThan(keyPath, value):
            Target.sqliteField(of: keyPath).quotedFieldName
            ">"
            value.description
            
        case let .between(keyPath, lhs, rhs):
            Target.sqliteField(of: keyPath).quotedFieldName
            "BETWEEN"
            lhs.description
            "AND"
            rhs.description
            
        case let .notBetween(keyPath, lhs, rhs):
            Target.sqliteField(of: keyPath).quotedFieldName
            "NOT BETWEEN"
            lhs.description
            "AND"
            rhs.description
            
        case let .isNull(keyPath):
            Target.sqliteField(of: keyPath).quotedFieldName
            "IS NULL"

        case let .isNotNull(keyPath):
            Target.sqliteField(of: keyPath).quotedFieldName
            "IS NOT NULL"
            
        case let .in(keyPath, values):
            Target.sqliteField(of: keyPath).quotedFieldName
            "IN"
            SQLite3.enclosedList(values)
            
        case let .notIn(keyPath, values):
            Target.sqliteField(of: keyPath).quotedFieldName
            "NOT IN"
            SQLite3.enclosedList(values)

        case let .like(keyPath, pattern):
            Target.sqliteField(of: keyPath).quotedFieldName
            "LIKE"
            SQLite3.quotedText(pattern)

        case let .notLike(keyPath, pattern):
            Target.sqliteField(of: keyPath).quotedFieldName
            "NOT LIKE"
            SQLite3.quotedText(pattern)

        case let .regularExpression(keyPath, pattern, caseSensitive: true):
            Target.sqliteField(of: keyPath).quotedFieldName
            "REGEXP BINARY"
            SQLite3.quotedText(pattern)

        case let .regularExpression(keyPath, pattern, caseSensitive: false):
            Target.sqliteField(of: keyPath).quotedFieldName
            "REGEXP"
            SQLite3.quotedText(pattern)

        case let .rawSQL(sql):
            sql
        }
    }
}
