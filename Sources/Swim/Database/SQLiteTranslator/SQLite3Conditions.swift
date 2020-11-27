//
//  SQLite3StatementWhere.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/25.
//

infix operator <=>
infix operator =~

public protocol SQLite3Condition {
    
    var sql: String { get }
}

public func == <Target : SQLite3Translateable>(lhs: PartialKeyPath<Target>, rhs: SQLite3.Value) -> SQLite3.Conditions<Target> {
    
    return .init(.equal(lhs, rhs))
}

public func != <Target : SQLite3Translateable>(lhs: PartialKeyPath<Target>, rhs: SQLite3.Value) -> SQLite3.Conditions<Target> {
    
    return .init(.notEqual(lhs, rhs))
}

public func <=> <Target : SQLite3Translateable>(lhs: PartialKeyPath<Target>, rhs: SQLite3.Value) -> SQLite3.Conditions<Target> {
    
    return .init(.equalConsiderNull(lhs, rhs))
}

public func == <Target : SQLite3Translateable>(lhs: PartialKeyPath<Target>, rhs: ClosedRange<SQLite3.Value>) -> SQLite3.Conditions<Target> {
    
    return .init(.between(lhs, rhs.lowerBound, rhs.upperBound))
}

public func != <Target : SQLite3Translateable>(lhs: PartialKeyPath<Target>, rhs: ClosedRange<SQLite3.Value>) -> SQLite3.Conditions<Target> {
    
    return .init(.notBetween(lhs, rhs.lowerBound, rhs.upperBound))
}

public func == <Target : SQLite3Translateable>(lhs: PartialKeyPath<Target>, rhs: Array<SQLite3.Value>) -> SQLite3.Conditions<Target> {
    
    return .init(.in(lhs, rhs))
}

public func != <Target : SQLite3Translateable>(lhs: PartialKeyPath<Target>, rhs: Array<SQLite3.Value>) -> SQLite3.Conditions<Target> {
    
    return .init(.notIn(lhs, rhs))
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

public func =~ <Target : SQLite3Translateable>(path: PartialKeyPath<Target>, pattern: String) -> SQLite3.Conditions<Target> {
    
    return .init(.regularExpression(path, pattern, caseSensitive: false))
}

extension SQLite3 {
    
    @_functionBuilder
    public struct ConditionsSatisfyAll<Target> where Target : SQLite3Translateable {
        
        public static func buildBlock(_ condition: SQLite3.Conditions<Target>, _ conditions: SQLite3.Conditions<Target> ...) -> SQLite3.Conditions<Target> {
            
            return conditions.reduce(condition) { $0.and($1) }
        }
    }
    
    @_functionBuilder
    public struct ConditionsSatisfyEither<Target> where Target : SQLite3Translateable {
        
        public static func buildBlock(_ condition: SQLite3.Conditions<Target>, _ conditions: SQLite3.Conditions<Target> ...) -> SQLite3.Conditions<Target> {
            
            return conditions.reduce(condition) { $0.or($1) }
        }
    }
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
        
        public static func isNull(_ path: Path) -> Self {
            
            return .init(.isNull(path))
        }
        
        public static func isNotNull(_ path: Path) -> Self {
            
            return .init(.isNotNull(path))
        }

        public static func `in`(_ path: Path, _ values: [Value]) -> Self {
        
            return .init(.in(path, values))
        }
        
        public static func notIn(_ path: Path, _ values: [Value]) -> Self {
        
            return .init(.notIn(path, values))
        }
        
        public static func like(_ path: Path, _ pattern: String) -> Self {
        
            return .init(.like(path, pattern))
        }
        
        public static func notLike(_ path: Path, _ pattern: String) -> Self {
        
            return .init(.notLike(path, pattern))
        }

        public static func regularExpression(_ path: Path, _ pattern: String, caseSensitive: Bool) -> Self {
        
            return .init(.regularExpression(path, pattern, caseSensitive: caseSensitive))
        }
        
        public static func rawSQL(_ sql: String) -> Self {
            
            return .init(.rawSQL(sql))
        }
        
        public static func satisfyAll(@SQLite3.ConditionsSatisfyAll<Target> _ predicate: () -> Self) -> Self {
        
            return predicate()
        }
        
        public static func satisfyEither(@SQLite3.ConditionsSatisfyEither<Target> _ predicate: () -> Self) -> Self {
        
            return predicate()
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
    
    @SpaceSeparatedList
    public var sql: String {
        
        switch count {
        
        case 0:
            nil
            
        case 1:
            first!.sql
            
        default:
            SQLite3.enclosedList(map(\.sql), separator: " ")
        }
    }
}

extension SQLite3.Conditions.Item : SQLite3Condition {

    var sql: String {

        switch self {
        
        case .element(let element):
            return SQLite3.enclosedText(element.sql)
            
        case .root(let elements):
            return SQLite3.enclosedText(elements.sql)
            
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
