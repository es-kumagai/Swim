//
//  SQLiteArrayColumnMetadata.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/12.
//

extension SQLiteArray {
    
    internal struct ColumnMetadata {
        
        var name: String
        var datatype: SQLite3.DataType
        var nullable: Bool
        var offset: Int
        var size: Int
    }
}

extension SQLiteArray.ColumnMetadata {
    
    var sql: String {
        
        return SQLite3.fieldName(name)
            + " "
            + datatype.description
            + (nullable ? "" : " NOT NULL")
    }
}
