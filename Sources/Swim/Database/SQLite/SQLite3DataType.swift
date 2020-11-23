//
//  SQLite3StatementColumnDataType.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/10.
//

import SQLite3

extension SQLite3 {
    
    /// [Swim] Data type of SQLite3; BLOB is NOT supported yet.
    public enum DataType {
    
        case integer
        case real
        case text
//        case blob
    
        public init?(code: Int32) throws {
            
            switch code {
                
            case SQLITE_INTEGER:
                self = .integer
                
            case SQLITE_FLOAT:
                self = .real
                
            case SQLITE_TEXT:
                self = .text
                
//            case SQLITE_BLOB:
//                self = .blob
                
            case SQLITE_NULL:
                return nil
                
            default:
                throw SQLite3.TranslationError.unsupportedSQLiteType(code.description)
            }
        }
        
        public var code: Int32 {
            
            switch self {
                
            case .integer:
                return SQLITE_INTEGER
                
            case .real:
                return SQLITE_FLOAT
                
            case .text:
                return SQLITE_TEXT
                
//            case .blob:
//                return SQLITE_BLOB
            }
        }
    }    
}

extension SQLite3.DataType : CustomStringConvertible {
    
    public init?(_ description: String) throws {
        
        switch description {
        
        case "NULL":
            return nil
            
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
