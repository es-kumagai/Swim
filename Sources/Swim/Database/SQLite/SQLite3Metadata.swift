//
//  SQLite3TranslatorMetadata.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/23.
//

extension SQLite3.Translator {
    
    internal struct Metadata {
        
        var name: String
        var datatype: SQLite3.DataType
        var nullable: Bool
        var offset: Int
        var size: Int
    }
}

extension SQLite3.Translator.Metadata {
    
    var sql: String {
        
        return SQLite3.fieldName(name)
            + " "
            + datatype.description
            + (nullable ? "" : " NOT NULL")
    }
}
