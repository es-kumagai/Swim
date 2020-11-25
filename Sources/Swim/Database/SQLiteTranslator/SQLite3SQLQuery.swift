//
//  SQLite3SQLQuery.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/25.
//

extension SQLite3.SQL {

    public enum Query {
        
        case createTable
        case select
        case insert(Target)
        case delete
    }
}

extension SQLite3.SQL.Query {

    public var sqlWithoutConditions: String {
        
        switch self {
        
        case .createTable:
            return "CREATE TABLE \(SQLite3.fieldName(Target.tableName)) (\(Target.declaresSQL))"
            
        case .select:
            return "SELECT * FROM \(SQLite3.fieldName(Target.tableName))"
            
        case .insert(let value):
            return "INSERT INTO \(SQLite3.fieldName(value.tableName)) (\(value.fieldsSQL)) VALUES (\(value.valuesSQL))"
            
        case .delete:
            return "DELETE * FROM \(SQLite3.fieldName(Target.tableName))"
        }
    }
}
