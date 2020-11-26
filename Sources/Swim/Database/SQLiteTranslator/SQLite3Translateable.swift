//
//  SQLite3Translateable.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/23.
//

public protocol SQLite3Translateable {
    
    typealias Column = SQLite3.ColumnMetadata<Self>
    
    static var tableName: String { get }
    
    /// [Swim] The definition for mapping Swift properties and SQLite3 columns.
    /// This property is referenced when using metadata by a 'Translator', a 'SQL' and so on.
    /// This value can be created by Function builder with attribute '@SQLite3.ColumnsDeclaration'.
    static var sqlite3Columns: [Column] { get }
}

extension SQLite3Translateable {
    
    public static var tableName: String {
    
        return "\(Self.self)"
    }
    
    public var tableName: String {
        
        return Self.tableName
    }
    
    public static var quotedTableName: String {
        
        return SQLite3.quotedFieldName(tableName)
    }
    
    public var quotedTableName: String {
        
        return Self.quotedTableName
    }
    
    public static func sqliteField(by name: String) -> SQLite3.Field {
        
        guard let column = sqlite3Columns.first(where: { $0.field.name == name }) else {

            fatalError("Specified name '\(name)' is not defined in 'sqlite3Columns'.")
        }
        
        return column.field
    }
    
    public static func sqliteField(of keyPath: PartialKeyPath<Self>) -> SQLite3.Field {
        
        guard let column = sqlite3Columns.first(where: { $0.keyPath == keyPath }) else {

            fatalError("Specified key path is not defined in 'sqlite3Columns'.")
        }
        
        return column.field
    }
    
    public static var declaresSQL: String {
        
        return sqlite3Columns.map(\.declareSQL).joined(separator: ", ")
    }
    
    public static var fieldsSQL: String {
        
        return sqlite3Columns.map(\.field.sql).joined(separator: ", ")
    }
    
    public var fieldsSQL: String {
        
        return Self.fieldsSQL
    }
    
    public var valuesSQL: String {
        
        let values = Self.sqlite3Columns.map { column -> String in
            
            let value = self[keyPath: column.keyPath]
            
            switch (column.datatype, column.nullable) {

            case (.variant, true):
                return (value as? SQLite3.Value)?.description ?? "NULL"
  
            case (.variant, false):
                return (value as! SQLite3.Value).description
                
            case (.integer, true):
                return (value as? Int)?.description ?? "NULL"
                
            case (.integer, false):
                return (value as! Int).description
                
            case (.real, true):
                return (value as? Double)?.description ?? "NULL"
                
            case (.real, false):
                return (value as! Double).description
                
            case (.text, true):
                 return (value as? String).map(SQLite3.quotedText) ?? "NULL"
                
            case (.text, false):
                return SQLite3.quotedText(value as! String)
            }
        }
        
        return values.joined(separator: ", ")
    }
}
