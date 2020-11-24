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
    
    public var declaredType: SQLite3.DefineDataType {
    
        let typename = String(cString: sqlite3_column_decltype(statement.handle, index))
        
        guard let type = try! SQLite3.DefineDataType(typename) else {
            
            fatalError("Unsupported columns type '\(typename)'.")
        }
        
        return type
    }
    
    public var actualType: SQLite3.ActualDataType {
        
        let code = sqlite3_column_type(statement.handle, index)
        
        guard let type = SQLite3.ActualDataType(code: code) else {
            
            fatalError("Unsupported data type. (code = \(code))")
        }
        
        return type
    }
    
    public var isNull: Bool {
        
        return actualType == .null
    }
    
    public var value: SQLite3.Value {
        
        switch declaredType {
        
        case .integer:
            return SQLite3.Value(integerValue)
            
        case .real:
            return SQLite3.Value(realValue)

        case .text:
            return SQLite3.Value(textValue)
            
        case .variant:
            
            switch actualType {
            
            case .null:
                return SQLite3.Value.unspecified(nil)
                
            case .integer:
                return SQLite3.Value.unspecified(integerValue)
                
            case .real:
                return SQLite3.Value.unspecified(realValue)
                
            case .text:
                return SQLite3.Value.unspecified(textValue)
            }
        }
    }
    
    public var bytesValue: Int32? {

        return isNull ? nil : sqlite3_column_bytes(statement.handle, index)
    }
    
    public var realValue: Double? {
        
        return isNull ? nil : sqlite3_column_double(statement.handle, index)
    }
    
    public var integerValue: Int? {
    
        return isNull ? nil : Int(sqlite3_column_int64(statement.handle, index))
    }
    
    public var textValue: String? {
    
        guard !isNull else {
            
            return nil
        }
        
        return String(cString:
    
            unsafeBitCast(sqlite3_column_text(statement.handle, index), to: UnsafePointer<Int8>.self)
            )
    }
}

extension SQLite3.Column : CustomStringConvertible {
    
    public var description: String {
        
        switch self.actualType {
        
        case .integer:
            return integerValue!.description
            
        case .real:
            return realValue!.description
            
        case .text:
            return SQLite3.quoted(textValue!)
            
        case .null:
            return "NULL"
        }
    }
}
