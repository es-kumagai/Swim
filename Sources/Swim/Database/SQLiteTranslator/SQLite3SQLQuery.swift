//
//  SQLite3SQLQuery.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/25.
//

extension SQLite3.SQL {

    public enum Query {
        
        case createTable
        case select(Array<SQLite3.Field> = [])
        case insert(Target)
        case delete
    }
}

extension SQLite3.SQL.Query {

    @SpaceSeparatedList
    public var sqlWithoutConditions: String {
        
        switch self {
        
        case .createTable:
            "CREATE TABLE"
            Target.quotedTableName
            SQLite3.enclosedText(Target.declaresSQL)
            
        case .select(let fields) where fields.isEmpty:
            "SELECT * FROM"
            Target.quotedTableName

        case .select(let fields):
            "SELECT"
            SQLite3.listedText(fields.map(\.sql))
            "FROM"
            Target.quotedTableName

        case .insert(let value):
            "INSERT INTO"
            value.quotedTableName
            SQLite3.enclosedText(value.fieldListSQL)
            "VALUES"
            SQLite3.enclosedText(value.valuesSQL)
            
        case .delete:
            "DELETE * FROM"
            Target.quotedTableName
       }
    }
}
