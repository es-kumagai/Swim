//
//  SQLite3StatementColumn.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/10.
//

import SQLite3

extension SQLite3 {
    
    public final class Column {
        
        public private(set) var statement: Statement
        public private(set) var index: Int32
        
        internal init<Index : BinaryInteger>(statement: Statement, index: Index) {
            
            self.statement = statement
            self.index = Int32(index)
        }
    }
}

extension SQLite3.Column {
    
    public var name: String {
    
        return String(cString: sqlite3_column_name(statement.handle, index))
    }
    
    public var declaredType: SQLite3.DataType {
    
        let typename = String(cString: sqlite3_column_decltype(statement.handle, index))
        
        guard let type = try! SQLite3.DataType(typename) else {
            
            fatalError("Unsupported columns type '\(typename)'.")
        }
        
        return type
    }
    
    public var actualType: SQLite3.DataType? {
        
        return try! SQLite3.DataType(code: sqlite3_column_type(statement.handle, index))
    }
    
    public var isNull: Bool {
        
        return actualType == nil
    }
    
    public var bytesValue: Int32 {
        
        return sqlite3_column_bytes(statement.handle, index)
    }
    
    public var realValue: Double {
        
        return sqlite3_column_double(statement.handle, index)
    }
    
    public var integerValue: Int {
    
        return Int(sqlite3_column_int64(statement.handle, index))
    }
    
    public var textValue: String {
    
        return String(cString:
    
            unsafeBitCast(sqlite3_column_text(statement.handle, index), to: UnsafePointer<Int8>.self)
            )
    }
}

extension SQLite3.Column : CustomStringConvertible {
    
    public var description: String {
        
        switch self.actualType {
        
        case .integer:
            return integerValue.description
            
        case .real:
            return realValue.description
            
        case .text:
            return SQLite3.quoted(textValue)
            
        case .none:
            return "NULL"
        }
    }
}
