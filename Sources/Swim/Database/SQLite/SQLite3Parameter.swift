//
//  SQLite3StatementBindParameter.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/10.
//

import SQLite3

extension SQLite3 {
    
    public final class Parameter {
        
        public private(set) var statement: Statement
        public private(set) var index: Int32
        
        init(statement: Statement, index: Int32) {
        
            self.statement = statement
            self.index = index
        }
        
        convenience init(statement: Statement, name: String) {
            
            let index = sqlite3_bind_parameter_index(statement.handle, name)
            
            guard index != 0 else {
                
                fatalError("Parameter `\(name)` is not found.")
            }
            
            self.init(statement: statement, index: index)
        }
    }
}

extension SQLite3.Parameter {
    
    public func bind(_ value: Double) throws {
        
        try SQLite3.ResultCode(sqlite3_bind_double(statement.handle, index, value)).throwIfError()
    }
    
    public func bind<Integer: BinaryInteger>(_ value: Integer) throws {
        
        try SQLite3.ResultCode(sqlite3_bind_int64(statement.handle, index, Int64(value))).throwIfError()
    }
    
    public func bind(null _: Void) throws {
        
        try SQLite3.ResultCode(sqlite3_bind_null(statement.handle, index)).throwIfError()
    }
    
    public func bind(_ value: String) throws {
        
        try SQLite3.ResultCode(sqlite3_bind_text(statement.handle, index, value, -1, { _ in })).throwIfError()
    }
    
    public func bind(_ value: OpaquePointer) throws {
        
        try SQLite3.ResultCode(sqlite3_bind_value(statement.handle, index, value)).throwIfError()
    }
    
    public func bind(zeroblobLength length: Int) throws {
        
        try SQLite3.ResultCode(sqlite3_bind_zeroblob(statement.handle, index, Int32(length))).throwIfError()
    }
}
