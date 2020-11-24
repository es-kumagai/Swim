//
//  SQLite3StatementWhere.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/25.
//

extension SQLite3.Translator {
    
    public struct Condition {
        
        private var conditions: Array<Item>
        
        public init(_ element: Element) {

            conditions = [.rootElement(element)]
        }
        
        public init(_ condition: Condition) {

            conditions = [.rootCondition(condition)]
        }
    }
}

internal extension SQLite3.Translator.Condition {
    
    enum Item {
    
        case rootCondition(SQLite3.Translator<Type>.Condition)
        case rootElement(Element)
        case andCondition(SQLite3.Translator<Type>.Condition)
        case andElement(Element)
        case orCondition(SQLite3.Translator<Type>.Condition)
        case orElement(Element)
    }
}

internal extension SQLite3.Translator.Condition.Item {

    var sql: String {
        
        switch self {
        
        case .rootCondition(let condition):
            return condition.sql
            
        case .rootElement(let element):
            return element.sql
            
        case .andCondition(let condition):
            return "AND (\(condition.sql))"

        case .andElement(let element):
            return "AND \(element.sql)"
            
        case .orCondition(let condition):
            return "OR (\(condition.sql))"
            
        case .orElement(let element):
            return "OR \(element.sql)"
        }
    }
}

extension SQLite3.Translator.Condition {
 
    private init(conditions: Array<Item>) {
        
        self.conditions = conditions
    }

    public func and(_ condition: SQLite3.Translator<Type>.Condition) -> SQLite3.Translator<Type>.Condition {
        
        return SQLite3.Translator<Type>.Condition(conditions: conditions + [.andCondition(condition)])
    }

    public func and(_ element: Element) -> SQLite3.Translator<Type>.Condition {
        
        return SQLite3.Translator<Type>.Condition(conditions: conditions + [.andElement(element)])
    }
    
    public func or(_ condition: SQLite3.Translator<Type>.Condition) -> SQLite3.Translator<Type>.Condition {
        
        return SQLite3.Translator<Type>.Condition(conditions: conditions + [.orCondition(condition)])
    }
    
    public func or(_ element: Element) -> SQLite3.Translator<Type>.Condition {
        
        return SQLite3.Translator<Type>.Condition(conditions: conditions + [.orElement(element)])
    }
}

extension SQLite3.Translator.Condition {
    
    public var sql: String {
        
        return conditions.map(\.sql).joined(separator: " ")
    }
}
