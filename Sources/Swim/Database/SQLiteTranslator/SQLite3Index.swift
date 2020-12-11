//
//  SQLite3Index.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/27.
//

extension SQLite3 {

    public struct Index<Target> where Target : SQLite3Translateable {
        
        public var shortName: String
        public var fieldNames: [String]
        public var unique: Bool
        
        public init(_ shortName: String, fieldNames: [String], unique: Bool = false) {
            
            self.shortName = shortName
            self.fieldNames = fieldNames
            self.unique = unique
        }
    }
}

extension SQLite3.Index {
    
    public var fullName: String {
        
        return "Index_\(Target.sqlite3TableName)_\(shortName)"
    }
    
    @SpaceSeparatedList
    public var sql: String {
        
        unique ? "UNIQUE" : nil
        "INDEX"
        SQLite3.quotedFieldName(fullName)
        "ON"
        SQLite3.Translator<Target>.quotedTableName
        SQLite3.enclosedList(fieldNames.map(SQLite3.quotedFieldName))
    }
}
