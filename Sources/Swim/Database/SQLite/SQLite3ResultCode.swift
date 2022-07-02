//
//  SQLite3ResultCode.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/10.
//

import SQLite3

extension SQLite3 {
    
    public struct ResultCode : Error {
        
        public private(set) var rawValue: Int32
        
        public init(_ rawValue: Int32) {
            
            self.rawValue = rawValue
        }
    }
}

extension SQLite3.ResultCode {
    
    public static var OK = SQLite3.ResultCode(SQLITE_OK)
    
    public var isOK: Bool {

        return rawValue == SQLITE_OK
    }
    
    public var isRow: Bool {
        
        return rawValue == SQLITE_ROW
    }
    
    public var isDone: Bool {
        
        return rawValue == SQLITE_DONE
    }
    
    public func throwIfError() throws {
        
        guard isOK || isRow || isDone else {
            
            throw self
        }
    }
}

extension SQLite3.ResultCode : CustomStringConvertible {
    
    public var description: String {

        return String(cString: sqlite3_errstr(rawValue))
    }
}

extension SQLite3.ResultCode : CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        switch rawValue {
        
        case SQLITE_OK:
            return "SQLITE_OK"
            
        case SQLITE_ERROR:
            return "SQLITE_ERROR"
            
        case SQLITE_INTERNAL:
            return "SQLITE_INTERNAL"
            
        case SQLITE_PERM:
            return "SQLITE_PERM"
            
        case SQLITE_ABORT:
            return "SQLITE_ABORT"
            
        case SQLITE_BUSY:
            return "SQLITE_BUSY"
            
        case SQLITE_LOCKED:
            return "SQLITE_LOCKED"
            
        case SQLITE_NOMEM:
            return "SQLITE_NOMEM"
            
        case SQLITE_READONLY:
            return "SQLITE_READONLY"
            
        case SQLITE_INTERRUPT:
            return "SQLITE_INTERRUPT"
            
        case SQLITE_IOERR:
            return "SQLITE_IOERR"
            
        case SQLITE_CORRUPT:
            return "SQLITE_CORRUPT"
            
        case SQLITE_NOTFOUND:
            return "SQLITE_NOTFOUND"
            
        case SQLITE_FULL:
            return "SQLITE_FULL"
            
        case SQLITE_CANTOPEN:
            return "SQLITE_CANTOPEN"
            
        case SQLITE_PROTOCOL:
            return "SQLITE_PROTOCOL"
            
        case SQLITE_EMPTY:
            return "SQLITE_EMPTY"
            
        case SQLITE_SCHEMA:
            return "SQLITE_SCHEMA"
            
        case SQLITE_TOOBIG:
            return "SQLITE_TOOBIG"
            
        case SQLITE_CONSTRAINT:
            return "SQLITE_CONSTRAINT"
            
        case SQLITE_MISMATCH:
            return "SQLITE_MISMATCH"
            
        case SQLITE_MISUSE:
            return "SQLITE_MISUSE"
            
        case SQLITE_NOLFS:
            return "SQLITE_NOLFS"
            
        case SQLITE_AUTH:
            return "SQLITE_AUTH"
            
        case SQLITE_FORMAT:
            return "SQLITE_FORMAT"
            
        case SQLITE_RANGE:
            return "SQLITE_RANGE"
            
        case SQLITE_NOTADB:
            return "SQLITE_NOTADB"
            
        case SQLITE_NOTICE:
            return "SQLITE_NOTICE"
            
        case SQLITE_WARNING:
            return "SQLITE_WARNING"
            
        case SQLITE_ROW:
            return "SQLITE_ROW"
            
        case SQLITE_DONE:
            return "SQLITE_DONE"
            
        case let code:
            return "\(code)"
        }
    }
}

extension SQLite3.ResultCode : Equatable {
    
}
