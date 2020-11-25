//
//  SQLite3StatementWhere.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/25.
//

extension SQLite3.Translator {
    
    public struct Condition {
        
        private var conditions: Array<Item>
        
        private init(_ element: Element) {

            conditions = [.rootElement(element)]
        }
        
        private init(_ condition: Condition) {

            conditions = [.rootCondition(condition)]
        }
        
        static func condition(_ element: Element) -> Condition {
            
            return self.init(element)
        }
        
        static func conditions(_ condition: Condition) -> Condition {
            
            return self.init(condition)
        }
    }
}

internal extension SQLite3.Translator.Condition {
    
    enum Item {
    
        case rootCondition(SQLite3.Translator<Target>.Condition)
        case rootElement(Element)
        case andCondition(SQLite3.Translator<Target>.Condition)
        case andElement(Element)
        case orCondition(SQLite3.Translator<Target>.Condition)
        case orElement(Element)
    }
}

internal extension SQLite3.Translator.Condition.Item {

    var sql: String {
        
        switch self {
        
        case .rootCondition(let condition):
            return "(\(condition.sql))"
            
        case .rootElement(let element):
            return "(\(element.sql))"
            
        case .andCondition(let condition):
            return "AND (\(condition.sql))"

        case .andElement(let element):
            return "AND (\(element.sql))"
            
        case .orCondition(let condition):
            return "OR (\(condition.sql))"
            
        case .orElement(let element):
            return "OR (\(element.sql))"
        }
    }
}

extension SQLite3.Translator.Condition {
 
    private init(conditions: Array<Item>) {
        
        self.conditions = conditions
    }

    public func and(_ condition: SQLite3.Translator<Target>.Condition) -> SQLite3.Translator<Target>.Condition {
        
        return SQLite3.Translator<Target>.Condition(conditions: conditions + [.andCondition(condition)])
    }

    public func and(_ element: Element) -> SQLite3.Translator<Target>.Condition {
        
        return SQLite3.Translator<Target>.Condition(conditions: conditions + [.andElement(element)])
    }
    
    public func or(_ condition: SQLite3.Translator<Target>.Condition) -> SQLite3.Translator<Target>.Condition {
        
        return SQLite3.Translator<Target>.Condition(conditions: conditions + [.orCondition(condition)])
    }
    
    public func or(_ element: Element) -> SQLite3.Translator<Target>.Condition {
        
        return SQLite3.Translator<Target>.Condition(conditions: conditions + [.orElement(element)])
    }
}

extension SQLite3.Translator.Condition {
    
    public var sql: String {
        
        return conditions.map(\.sql).joined(separator: " ")
    }
}
