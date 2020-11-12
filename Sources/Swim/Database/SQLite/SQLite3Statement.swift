//
//  SQLite3Statement.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/10.
//

import SQLite3

extension SQLite3 {
            
    public final class Statement {
        
        internal private(set) var db: SQLite3
        internal private(set) var handle: OpaquePointer
        internal private(set) var columnNames: Array<String>
        
        public private(set) var sql: String
        public private(set) var columns: Columns!

        init(db: SQLite3, sql: String) throws {
            
            var handle: OpaquePointer?

            try ResultCode(sqlite3_prepare_v2(db.pDB, sql, -1, &handle, nil)).throwIfError()
            
            self.db = db
            self.sql = sql
            self.handle = handle!
            self.columnNames = Self.columnNames(of: handle!)
            
            self.columns = Columns(db: db, statement: self)
        }
        
        deinit {
            
            try! ResultCode(sqlite3_finalize(handle)).throwIfError()
        }
    }
}

extension SQLite3.Statement {
    
    public var columnCount: Int {
    
        return Int(sqlite3_column_count(handle))
    }
    
    @discardableResult
    public func step() throws -> Bool {
        
        switch sqlite3_step(handle) {
            
        case SQLITE_ROW:
            return true
            
        case SQLITE_DONE:
            return false
            
        case let code:
            throw SQLite3.ResultCode(code)
        }
    }
    
    public func parameter(at index: Int32) -> SQLite3.Parameter {
    
        return SQLite3.Parameter(statement: self, index: index)
    }
    
    public func parameter(_ name: String) -> SQLite3.Parameter {
    
        return SQLite3.Parameter(statement: self, name: name)
    }
    
    public func reset() throws {
        
        try SQLite3.ResultCode(sqlite3_reset(handle)).throwIfError()
    }
    
    public func clearBindings() throws {
        
        try SQLite3.ResultCode(sqlite3_clear_bindings(handle)).throwIfError()
    }
}

private extension SQLite3.Statement {
    
    /// Update column names. This method is called by `prepare` method.
    static func columnNames(of handle: OpaquePointer) -> Array<String> {

        let count = sqlite3_column_count(handle)
        
        guard count > 0 else {
            
            return []
        }
        
        return (0 ..< count).map { cidx in
            
            String(cString: sqlite3_column_name(handle, cidx))
        }
    }
}

extension SQLite3.Statement : Sequence {
    
    public func makeIterator() -> SQLite3.StatementIterator {
        
        return SQLite3.StatementIterator(statement: self)
    }
}
