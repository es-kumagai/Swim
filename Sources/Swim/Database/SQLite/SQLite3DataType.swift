//
//  SQLite3StatementColumnDataType.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/10.
//

import SQLite3

extension SQLite3 {
    
    /// [Swim] Data type of SQLite3; BLOB is NOT supported yet.
    public enum DataType : RawRepresentable {
    
        case integer
        case real
        case text
//        case blob
        case null
    
        public init?(rawValue: Int32) {
            
            switch rawValue {
                
            case SQLITE_INTEGER:
                self = .integer
                
            case SQLITE_FLOAT:
                self = .real
                
            case SQLITE_TEXT:
                self = .text
                
//            case SQLITE_BLOB:
//                self = .blob
                
            case SQLITE_NULL:
                self = .null
                
            default:
                return nil
            }
        }
        
        public var rawValue: Int32 {
            
            switch self {
                
            case .integer:
                return SQLITE_INTEGER
                
            case .real:
                return SQLITE_FLOAT
                
            case .text:
                return SQLITE_TEXT
                
//            case .blob:
//                return SQLITE_BLOB
                
            case .null:
                return SQLITE_NULL
            }
        }
    }    
}

extension SQLite3.DataType : LosslessStringConvertible {
    
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
            
//        case "BLOB":
//            self = .blob
            
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
            
//        case .blob:
//            return "BLOB"
        }
    }
}
