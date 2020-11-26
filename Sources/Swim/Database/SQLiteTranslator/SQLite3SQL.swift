//
//  SQLite3SQL.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/25.
//

@_functionBuilder
struct SQLite3SQLBuilder {
    
    static func buildBlock(_ statements: String? ...) -> String {
        
        return statements
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    static func buildEither(first: String? ...) -> String {
        
        return first
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    static func buildEither(second: String? ...) -> String {
        
        return second
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}

public protocol SQLite3SQLKind {}

extension SQLite3 {
    
    public class WithConditions : SQLite3SQLKind {}
    public class NoConditions : SQLite3SQLKind {}
}

extension SQLite3 {
    
    public struct SQL<Target, Kind> where Target : SQLite3Translateable, Kind : SQLite3SQLKind {
        
        public private(set) var query: Query
        public private(set) var conditions: SQLite3.Conditions<Target>?

        private init(query: Query) {
        
            self.query = query
            self.conditions = nil
        }
    }
}

extension SQLite3.SQL where Kind == SQLite3.NoConditions {
    
    public static func createTable(_ table: Target.Type) -> Self {
    
        self.init(query: .createTable)
    }
    
    public static func select(from table: Target.Type) -> Self {
        
        self.init(query: .select())
    }
    
    public static func select(_ field: SQLite3.Field, from table: Target.Type) -> Self {
        
        self.init(query: .select([field]))
    }

    public static func select(_ fields: [SQLite3.Field], from table: Target.Type) -> Self {
        
        self.init(query: .select(fields))
    }
    
    public static func insert(_ value: Target) -> Self {
        
        self.init(query: .insert(value))
    }
    
    public static func delete(from table: Target.Type) -> Self {
        
        self.init(query: .delete)
    }
}

extension SQLite3.SQL where Kind == SQLite3.WithConditions {
    
    private init(query: Query, where conditions: SQLite3.Conditions<Target>) {
    
        self.query = query
        self.conditions = conditions
    }

    public static func select(from table: Target.Type, where conditions: SQLite3.Conditions<Target>) -> Self {
        
        self.init(query: .select(), where: conditions)
    }

    public static func select(_ field: SQLite3.Field, from table: Target.Type, where conditions: SQLite3.Conditions<Target>) -> Self {
        
        self.init(query: .select([field]), where: conditions)
    }

    public static func select(_ fields: [SQLite3.Field], from table: Target.Type, where conditions: SQLite3.Conditions<Target>) -> Self {
        
        self.init(query: .select(fields), where: conditions)
    }
    
    public static func insert(_ value: Target, where conditions: SQLite3.Conditions<Target>) -> Self {
        
        self.init(query: .insert(value), where: conditions)
    }
    
    public static func delete(from table: Target.Type, where conditions: SQLite3.Conditions<Target>) -> Self {
        
        self.init(query: .delete, where: conditions)
    }

    public func and(_ conditions: SQLite3.Conditions<Target>) -> Self {
    
        return Self.init(query: query, where: self.conditions?.and(conditions) ?? conditions)
    }

    public func or(_ conditions: SQLite3.Conditions<Target>) -> Self {
    
        return Self.init(query: query, where: self.conditions?.or(conditions) ?? conditions)
    }
}

extension SQLite3.SQL {
        
    @SQLite3SQLBuilder
    public func text() -> String {

        query.sqlWithoutConditions
        (conditions?.sql).map { "WHERE \($0)" }
    }
}

extension SQLite3.SQL : CustomStringConvertible {
    
    public var description: String {
        
        return text()
    }
}
