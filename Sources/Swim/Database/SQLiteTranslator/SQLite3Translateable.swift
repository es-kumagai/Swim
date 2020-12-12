//
//  SQLite3Translateable.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/23.
//

public protocol SQLite3Translateable {
    
    typealias Column = SQLite3.ColumnMetadata<Self>
    typealias Index = SQLite3.Index<Self>

    static var sqlite3TableName: String { get }
    
    /// [Swim] The definition for mapping Swift properties and SQLite3 columns.
    /// This property is referenced when using this metadata by a 'Translator', a 'SQL' and so on.
    /// This value can be created by Function builder with attribute '@SQLite3.ColumnsDeclaration'.
    static var sqlite3Columns: [Column] { get }

    /// [Swim] The definition of SQLite3 indexes.
    /// This property is referenced when using this metadata by a 'Translator', a 'SQL' and so on.
    /// This value can be created by Function builder with attribute '@SQLite3.IndexDeclaration'.
    static var sqlite3Indexes: [Index] { get }
    
    
    /// [Swim] The instance means default or empty value of this type.
    /// This value is used to base value for instantiation by Translator.
    static var sqlite3DefaultValue: Self { get }
}

extension SQLite3Translateable {
    
    public static var sqlite3TableName: String {
    
        return "\(Self.self)"
    }
    
    static var sqlite3Indexes: [Index] {
        
        return []
    }

    public static var sqlite3ColumnsForSelection: [Column] {
        
        return sqlite3Columns
    }

    public static var sqlite3ColumnsForDecleration: [Column] {
        
        return sqlite3Columns.filter { $0.bindingTo?.keyPath != nil }
    }

    public static var sqlite3ColumnsForInsertion: [Column] {
        
        return sqlite3ColumnsForDecleration.filter { !$0.ignoreInsertion }
    }
}
