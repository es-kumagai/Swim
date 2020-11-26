//
//  SQLite3StatementWhere.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/25.
//

public protocol SQLite3Condition {
    
    var sql: String { get }
}

public func == <Target : SQLite3Translateable>(lhs: PartialKeyPath<Target>, rhs: SQLite3.Value) -> SQLite3.Conditions<Target> {
    
    return .init(.equal(lhs, rhs))
}

public func != <Target : SQLite3Translateable>(lhs: PartialKeyPath<Target>, rhs: SQLite3.Value) -> SQLite3.Conditions<Target> {
    
    return .init(.notEqual(lhs, rhs))
}

public func <= <Target : SQLite3Translateable>(lhs: PartialKeyPath<Target>, rhs: SQLite3.Value) -> SQLite3.Conditions<Target> {
    
    return .init(.lessOrEqual(lhs, rhs))
}

public func >= <Target : SQLite3Translateable>(lhs: PartialKeyPath<Target>, rhs: SQLite3.Value) -> SQLite3.Conditions<Target> {
    
    return .init(.greaterOrEqual(lhs, rhs))
}

public func < <Target : SQLite3Translateable>(lhs: PartialKeyPath<Target>, rhs: SQLite3.Value) -> SQLite3.Conditions<Target> {
    
    return .init(.lessThan(lhs, rhs))
}

public func > <Target : SQLite3Translateable>(lhs: PartialKeyPath<Target>, rhs: SQLite3.Value) -> SQLite3.Conditions<Target> {
    
    return .init(.greaterThan(lhs, rhs))
}

extension SQLite3 {

    public struct Conditions<Target> where Target : SQLite3Translateable {
        
        public typealias Path = PartialKeyPath<Target>
        public typealias Value = SQLite3.Value

        private var conditions: Array<Item>
        
        public init(_ element: ConditionElement<Target>) {

            conditions = [.element(element)]
        }
        
        public static func between(_ path: Path, _ lhs: Value, _ rhs: Value) -> Self {
            
            return .init(.between(path, lhs, rhs))
        }
        
        public static func notBetween(_ path: Path, _ lhs: Value, _ rhs: Value) -> Self {
            
            return .init(.notBetween(path, lhs, rhs))
        }
        
        public static func rawSQL(_ sql: String) -> Self {
            
            return .init(.rawSQL(sql))
        }
        
        public static func satisfyAll(_ condition: Self, _ conditions: Self ...) -> Self {

            return conditions.reduce(condition) { $0.and($1) }
        }
        
        public static func satisfyEither(_ condition: Self, _ conditions: Self ...) -> Self {

            return conditions.reduce(condition) { $0.or($1) }
        }
    }
}

internal extension SQLite3.Conditions {
    
    enum Item {
    
        case element(SQLite3.ConditionElement<Target>)
        case root(Array<Self>)
        case and(Array<Self>)
        case or(Array<Self>)
    }
}

extension Collection where Element : SQLite3Condition {
    
    public var sql: String {
        
        switch count {
        
        case 0:
            return ""
            
        case 1:
            return first!.sql
            
        default:
            return "(\(map(\.sql).joined(separator: " ")))"
        }
    }
}

extension SQLite3.Conditions.Item : SQLite3Condition {

    var sql: String {

        switch self {
        
        case .element(let element):
            return "(\(element.sql))"
            
        case .root(let elements):
            return "\(elements.sql)"
            
        case .and(let elements):
            return "AND \(elements.sql)"
            
        case .or(let elements):
            return "OR \(elements.sql)"
        }
    }
}

extension SQLite3.Conditions {
 
    private init(conditions: Array<Item>) {
        
        self.conditions = conditions
    }

    public func and(_ condition: Self) -> Self {
        
        return Self(conditions: conditions + [.and(condition.conditions)])
    }
    
    public func or(_ condition: Self) -> Self {
        
        return Self(conditions: conditions + [.or(condition.conditions)])
    }
}

extension SQLite3.Conditions {
    
    public var sql: String {
        
        return conditions.sql
    }
}
