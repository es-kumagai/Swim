//
//  SQLite3Field.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/26.
//

extension SQLite3 {
    
    public struct Field {
        
        public var name: String
        public var function: String? = nil
        public var alias: String? = nil
        
        public init(_ name: String, function: String? = nil, alias: String? = nil) {
            
            self.name = name
            self.function = function
            self.alias = alias
        }
    }
}

extension SQLite3.Field {
    
    /// [Swim] The field name of this instance.
    /// This property returns 'alias' name if this instance has 'alias' name, otherwise returns 'name'.
    public var fieldName: String {
        
        return alias ?? name
    }
    
    /// [Swim] The quoted field name of this instance.
    /// This property returns 'alias' name if this instance has 'alias' name, otherwise returns 'name'.
    public var quotedFieldName: String {
        
        return SQLite3.quotedFieldName(fieldName)
    }
    
    /// [Swim] The quoted name of this instance.
    /// If the `name` is equals to "*", `name` is returned as is.
    public var quotedName: String {
    
        guard name != "*" else {
            
            return name
        }
        
        return SQLite3.quotedFieldName(name)
    }
    
    /// [Swim] The sql expression of this field.
    /// This expression's format is `function("name") AS "alias"`.
    @SQLite3SQLBuilder
    public var sql: String {

        switch function {
        
        case .some(let function):
            "\(function)(\(quotedName))"

        case .none:
            quotedName
        }
        
        alias.map { "AS \(SQLite3.quotedText($0))"}
    }
}

extension SQLite3.Field : ExpressibleByStringLiteral {
    
    public init(stringLiteral name: String) {
        
        self.init(name)
    }
}

extension SQLite3.Field : Equatable {
    
}
