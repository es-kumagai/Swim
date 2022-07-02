//
//  File.swift
//  
//  
//  Created by Tomohiro Kumagai on 2022/07/02
//  
//

import SQLite3

extension SQLite3 {
    
    public struct ErrorCode : Error {
        
        public private(set) var code: Int32
        public private(set) var message: String
        
        public init(code: Int32, message: String = "") {
            
            self.code = code
            self.message = message
        }
        
        public init?(on database: SQLite3) {
            
            let code = sqlite3_errcode(database.pDB)
            
            guard code == SQLITE_OK else {
                
                return nil
            }

            let message = sqlite3_errmsg(database.pDB).map { String(cString: $0) }
            
            self.init(code: code, message: message ?? "")
        }
    }
}

extension SQLite3.ErrorCode : CustomStringConvertible {
    
    public var description: String {

        message
    }
}

extension SQLite3.ErrorCode : CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        "\(message) (\(code))"
    }
}

extension SQLite3.ErrorCode : Equatable {
    
}
