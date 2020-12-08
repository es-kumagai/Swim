//
//  SQLite3TranslatorMetadata.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/23.
//

extension SQLite3 {
    
    public struct ColumnMetadata<Target> where Target : SQLite3Translateable {
        
        public var field: Field
        public var keyPath: PartialKeyPath<Target>
        public var datatype: SQLite3.DefineDataType
        public var nullable: Bool
        public var primaryKey: Bool
        
        /// [Swim] Create an instance that is analyzed by `keyPath`.
        /// If the `keyPath`'s type is not supported by SQLite3, aborting program in runtime.
        /// Currently, VARIANT always accept NULL.
        ///
        /// - Parameters:
        ///   - field: The SQLite filed of this metadata.
        ///   - value: The value that use to analyze metadata.
        ///   - offset: The offset data of this metadata.
        public init<Value>(_ field: Field, keyPath: KeyPath<Target, Value>, primaryKey: Bool = false) {
            
            self.field = field
            self.keyPath = keyPath as PartialKeyPath<Target>
            self.primaryKey = primaryKey
            
            switch Value.self {
            
            case SQLite3.Value.self:
                datatype = .variant
                nullable = true     // Currently, VARIANT always accept NULL.
                
            case Optional<SQLite3.Value>.self:
                datatype = .variant
                nullable = true
                
            case Int.self:
                datatype = .integer
                nullable = false
                
            case Optional<Int>.self:
                datatype = .integer
                nullable = true
                
            case String.self:
                datatype = .text
                nullable = false
                
            case Optional<String>.self:
                datatype = .text
                nullable = true
                
            case Double.self:
                datatype = .real
                nullable = false
                
            case Optional<Double>.self:
                datatype = .real
                nullable = true
                
            default:
                fatalError("Uncompatible Swift type: \(Value.self)")
            }
        }
    }
}

extension SQLite3.ColumnMetadata {
    
    var offset: Int {
    
        return MemoryLayout<Target>.offset(of: keyPath)!
    }
    
    @SpaceSeparatedList
    func declareSQL(markAsPrimaryKey: Bool) -> String {
        
        field.quotedName
        datatype.declareSQL
        
        if markAsPrimaryKey { "PRIMARY KEY" }
        if !nullable { "NOT NULL" }
    }
}

extension SQLite3.ColumnMetadata : Equatable {
    
}
