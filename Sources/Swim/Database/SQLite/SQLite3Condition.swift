//
//  SQLite3Condition.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/24.
//

extension SQLite3 {

    public enum Condition {
        
        case equal(String, SQLite3.Value)
        case notEqual(String, SQLite3.Value)
        case lessOrEqual(String, SQLite3.Value)
        case lessThan(String, SQLite3.Value)
        case greaterOrEqual(String, SQLite3.Value)
        case greaterThan(String, SQLite3.Value)
        case between(String, SQLite3.Value, SQLite3.Value)
    }
}

extension SQLite3.Condition : CustomDebugStringConvertible {

    public var debugDescription: String {
        
        return sql
    }
}

extension SQLite3.Condition {
    
    public var sql: String {
        
        switch self {
        
        case let .equal(name, value):
            return "\(SQLite3.fieldName(name)) = \(value)"

        case let .notEqual(name, value):
            return "\(SQLite3.fieldName(name)) != \(value)"
            
        case let .lessOrEqual(name, value):
            return "\(SQLite3.fieldName(name)) <= \(value)"
            
        case let .lessThan(name, value):
            return "\(SQLite3.fieldName(name)) < \(value)"
            
        case let .greaterOrEqual(name, value):
            return "\(SQLite3.fieldName(name)) >= \(value)"
            
        case let .greaterThan(name, value):
            return "\(SQLite3.fieldName(name)) > \(value)"
            
        case let .between(name, lhs, rhs):
            return "\(SQLite3.fieldName(name)) BETWEEN \(lhs) AND \(rhs)"
        }
    }
}
