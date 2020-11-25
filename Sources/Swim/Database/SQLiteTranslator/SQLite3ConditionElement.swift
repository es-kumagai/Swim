//
//  SQLite3Condition.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/24.
//

extension SQLite3.Translator.Condition {

    public enum Element {
        
        case equal(PartialKeyPath<Target>, SQLite3.Value)
        case notEqual(PartialKeyPath<Target>, SQLite3.Value)
        case lessOrEqual(PartialKeyPath<Target>, SQLite3.Value)
        case lessThan(PartialKeyPath<Target>, SQLite3.Value)
        case greaterOrEqual(PartialKeyPath<Target>, SQLite3.Value)
        case greaterThan(PartialKeyPath<Target>, SQLite3.Value)
        case between(PartialKeyPath<Target>, SQLite3.Value, SQLite3.Value)
        case notBetween(PartialKeyPath<Target>, SQLite3.Value, SQLite3.Value)
        case rawSQL(String)
    }
}

extension SQLite3.Translator.Condition.Element : CustomDebugStringConvertible {

    public var debugDescription: String {
        
        return sql
    }
}

extension SQLite3.Translator.Condition.Element {
    
    public var sql: String {
        
        switch self {
        
        case let .equal(keyPath, value):
            return "\(SQLite3.fieldName(Target.sqliteName(of: keyPath))) = \(value)"

        case let .notEqual(keyPath, value):
            return "\(SQLite3.fieldName(Target.sqliteName(of: keyPath))) != \(value)"
            
        case let .lessOrEqual(keyPath, value):
            return "\(SQLite3.fieldName(Target.sqliteName(of: keyPath))) <= \(value)"
            
        case let .lessThan(keyPath, value):
            return "\(SQLite3.fieldName(Target.sqliteName(of: keyPath))) < \(value)"
            
        case let .greaterOrEqual(keyPath, value):
            return "\(SQLite3.fieldName(Target.sqliteName(of: keyPath))) >= \(value)"
            
        case let .greaterThan(keyPath, value):
            return "\(SQLite3.fieldName(Target.sqliteName(of: keyPath))) > \(value)"
            
        case let .between(keyPath, lhs, rhs):
            return "\(SQLite3.fieldName(Target.sqliteName(of: keyPath))) BETWEEN \(lhs) AND \(rhs)"
            
        case let .notBetween(keyPath, lhs, rhs):
            return "\(SQLite3.fieldName(Target.sqliteName(of: keyPath))) NOT BETWEEN \(lhs) AND \(rhs)"
            
        case let .rawSQL(sql):
            return sql
        }
    }
}
