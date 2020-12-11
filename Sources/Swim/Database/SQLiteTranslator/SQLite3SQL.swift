//
//  SQLite3SQL.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/25.
//

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
    
    public static func dropTable(_ table: Target.Type) -> Self {
        
        self.init(query: .dropTable)
    }
    
    public static func createIndex(_ index: SQLite3.Index<Target>) -> Self {
     
        self.init(query: .createIndex(index))
    }
    
    public static func createIndexes(for target: Target.Type) -> [Self] {
        
        Target.sqlite3Indexes.map(createIndex)
    }
    
    public static func beginTransaction(on table: Target.Type) -> Self {
        
        self.init(query: .beginTransaction)
    }
    
    public static func commitTransaction(on table: Target.Type) -> Self {
        
        self.init(query: .commitTransaction)
    }
    
    public static func rollbackTransaction(on table: Target.Type) -> Self {
        
        self.init(query: .rollbackTransaction)
    }
    
    public static func select(_ fields: [SQLite3.Field] = [], from table: Target.Type, orderBy: [String] = []) -> Self {
        
        self.init(query: .select(fields, orderBy: orderBy))
    }
    
    public static func insert(_ value: Target) -> Self {
        
        self.init(query: .insert(value))
    }
    
    public static func replace(_ value: Target) -> Self {
        
        self.init(query: .replace(value))
    }
    
    public static func delete(from table: Target.Type) -> Self {
        
        self.init(query: .delete)
    }
    
    public static func vacuum() -> Self {
        
        self.init(query: .vacuum)
    }
}

extension SQLite3.SQL where Kind == SQLite3.WithConditions {
    
    private init(query: Query, where conditions: SQLite3.Conditions<Target>) {
    
        self.query = query
        self.conditions = conditions
    }

    public static func select(_ fields: [SQLite3.Field] = [], from table: Target.Type, where conditions: SQLite3.Conditions<Target>, orderBy: [String] = []) -> Self {
        
        self.init(query: .select(fields, orderBy: orderBy), where: conditions)
    }
    
    public static func insert(_ value: Target, where conditions: SQLite3.Conditions<Target>) -> Self {
        
        self.init(query: .insert(value), where: conditions)
    }
    
    public static func replace(_ value: Target, where conditions: SQLite3.Conditions<Target>) -> Self {
        
        self.init(query: .replace(value), where: conditions)
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
        
    @SpaceSeparatedList
    public func text() -> String {

        query.sqlWithoutConditions
        
        if let sql = conditions?.sql {
            
            "WHERE"
            sql
        }
        
        if let sql = query.sqlOnlyOrderBy {
            
            sql
        }
    }
}

extension SQLite3.SQL : CustomStringConvertible {
    
    public var description: String {
        
        return text()
    }
}

extension SQLite3 {
    
    @discardableResult
    public func execute<Target, Kind>(_ sql: SQLite3.SQL<Target, Kind>) throws -> SQLite3.Statement? where Target : SQLite3Translateable, Kind : SQLite3SQLKind {
        
        return try execute(sql: sql.text())
    }
    
    public func execute(@SQLBundle sqls predicate: () -> [String]) throws {
        
        for sql in predicate() {
            
            try execute(sql: sql)
        }
    }
}
