//
//  SQLite3Order.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/12.
//

extension SQLite3 {

    public struct Order {
        
        public enum OrderType {
        
            case ascending
            case descending
        }
        
        public var field: String
        public var type: OrderType
        
        public init(_ field: String, _ type: OrderType) {
            
            self.field = field
            self.type = type
        }
        
        public init(_ field: String) {
            
            self.field = field
            self.type = .ascending
        }
    }
}

extension SQLite3.Order : ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        
        self.init(value)
    }
}

extension SQLite3.Order {
    
    @SpaceSeparatedList
    public var sql: String {
        
        SQLite3.quotedFieldName(field)
        type.sql
    }
}

extension SQLite3.Order.OrderType {
    
    public var sql: String {
        
        switch self {
        
        case .ascending:
            return "ASC"
            
        case .descending:
            return "DESC"
        }
    }
}
