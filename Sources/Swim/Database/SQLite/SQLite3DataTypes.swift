//
//  SQLite3StatementColumnDataType.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/10.
//

import SQLite3

extension SQLite3 {

    /// [Swim] Data type of SQLite3; BLOB is NOT supported yet.
    public enum DefineDataType {
        
        case variant
        case integer
        case real
        case text
    }

    /// [Swim] Data type of SQLite3; BLOB is NOT supported yet.
    public enum ActualDataType {
    
        case null
        case integer
        case real
        case text
//        case blob
    }
}

extension SQLite3.DefineDataType {
    
}

extension SQLite3.ActualDataType {
    
    public init?(code: Int32) {
        
        switch code {
            
        case SQLITE_INTEGER:
            self = .integer
            
        case SQLITE_FLOAT:
            self = .real
            
        case SQLITE3_TEXT:
            self = .text
            
        case SQLITE_NULL:
            self = .null
            
        default:
            return nil
        }
    }
    
    public var code: Int32 {
    
        switch self {
        
        case .null:
            return SQLITE_NULL
            
        case .integer:
            return SQLITE_INTEGER
            
        case .real:
            return SQLITE_FLOAT
            
        case .text:
            return SQLITE3_TEXT
        }
    }
}

extension SQLite3.DefineDataType : CustomStringConvertible {
    
    public init?(_ description: String) throws {
        
        switch description {
        
        case "NULL":
            return nil
            
        case "":
            self = .variant
            
        case "INTEGER":
            self = .integer
            
        case "REAL":
            self = .real
            
        case "TEXT":
            self = .text
            
//        case "BLOB":
//            self = .blob
            
        default:
            throw SQLite3.TranslationError.unsupportedSQLiteType(description)
        }
    }
    
    public var description: String {
        
        switch self {
        
        case .variant:
            return ""
            
        case .integer:
            return "INTEGER"
            
        case .real:
            return "REAL"
            
        case .text:
            return "TEXT"
            
//        case .blob:
//            return "BLOB"
        }
    }
}

extension SQLite3.ActualDataType : CustomStringConvertible {
    
    public init?(_ description: String) {
        
        switch description {
        
        case "NULL":
            self = .null
            
        case "INTEGER":
            self = .integer
            
        case "REAL":
            self = .real
            
        case "TEXT":
            self = .text
            
        default:
            return nil
        }
    }
    
    public var description: String {
        
        switch self {
        
        case .null:
            return "NULL"
            
        case .integer:
            return "INTEGER"
            
        case .real:
            return "REAL"
            
        case .text:
            return "TEXT"
        }
    }
}
