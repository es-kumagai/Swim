//
//  SQLite3SQLQuery.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/25.
//

extension SQLite3.SQL {
    
    public enum Query {
        
        case createTable
        case dropTable
        case createIndex(SQLite3.Index<Target>)
        case beginTransaction
        case commitTransaction
        case rollbackTransaction
        case select(Array<SQLite3.Field> = [], orderBy: [String] = [])
        case insert(Target)
        case replace(Target)
        case delete
        case vacuum
    }
}

extension SQLite3.SQL.Query {

    fileprivate typealias Translator = SQLite3.Translator<Target>

    @SpaceSeparatedList
    public var sqlWithoutConditions: String {
        
        switch self {
        
        case .createTable:
            "CREATE TABLE"
            Translator.quotedTableName
            SQLite3.enclosedText(Translator.declaresSQL)
            
        case .dropTable:
            "DROP TABLE"
            SQLite3.Translator<Target>.quotedTableName
            
        case .createIndex(let index):
            "CREATE"
            index.sql
            
        case .beginTransaction:
            "BEGIN TRANSACTION"
            
        case .commitTransaction:
            "COMMIT TRANSACTION"
            
        case .rollbackTransaction:
            "ROLLBACK TRANSACTION"
            
        case .select(let fields, let orderBy):
            "SELECT"
            fields.isEmpty ? "*" : SQLite3.listedText(fields.map(\.sql))
            "FROM"
            Translator.quotedTableName

        case .insert(let value):
            "INSERT INTO"
            Translator.quotedTableName
            SQLite3.enclosedText(Translator.fieldsSQLForInsertion)
            "VALUES"
            SQLite3.enclosedText(Translator.valuesSQLForInsertion(of: value))
            
        case .replace(let value):
            "REPLACE INTO"
            Translator.quotedTableName
            SQLite3.enclosedText(Translator.fieldsSQL)
            "VALUES"
            SQLite3.enclosedText(Translator.valuesSQL(of: value))
            
        case .delete:
            "DELETE FROM"
            Translator.quotedTableName
            
        case .vacuum:
            "VACUUM"
       }
    }
    
    public var sqlOnlyOrderBy: String? {
        
        switch self {
        
        case .select(_, let orderBy) where !orderBy.isEmpty:
            return "ORDER BY " + SQLite3.listedText(orderBy.map(SQLite3.quotedFieldName))
            
        default:
            return nil
        }
    }
}
