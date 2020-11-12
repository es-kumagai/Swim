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
    
    public var type: SQLite3.DataType {
        
        return SQLite3.DataType(rawValue: sqlite3_column_type(statement.handle, index))!
    }
    
    public var isNull: Bool {
        
        return type == .null
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
