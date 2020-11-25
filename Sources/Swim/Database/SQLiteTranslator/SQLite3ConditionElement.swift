//
//  SQLite3Condition.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/24.
//

extension SQLite3 {

    public enum ConditionElement<Target> where Target : SQLite3Translateable {
        
        public typealias Path = PartialKeyPath<Target>
        
        case equal(Path, SQLite3.Value)
        case notEqual(Path, SQLite3.Value)
        case lessOrEqual(Path, SQLite3.Value)
        case lessThan(Path, SQLite3.Value)
        case greaterOrEqual(Path, SQLite3.Value)
        case greaterThan(Path, SQLite3.Value)
        case between(Path, SQLite3.Value, SQLite3.Value)
        case notBetween(Path, SQLite3.Value, SQLite3.Value)
        case rawSQL(String)
    }
}

extension SQLite3.ConditionElement : CustomDebugStringConvertible {

    public var debugDescription: String {
        
        return sql
    }
}

extension SQLite3.ConditionElement {
    
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
