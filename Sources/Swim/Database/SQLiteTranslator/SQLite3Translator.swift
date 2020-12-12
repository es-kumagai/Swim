//
//  SQLite3Translator.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/23.
//

extension SQLite3 {
    
    public struct Translator<Target> where Target : SQLite3Translateable {
                
        public typealias SQLWithNoConditions = SQLite3.SQL<Target, SQLite3.NoConditions>
        public typealias SQLWithConditions = SQLite3.SQL<Target, SQLite3.WithConditions>
        public typealias Conditions = SQLite3.Conditions<Target>
        public typealias Column = SQLite3.ColumnMetadata<Target>
        
        /// [Swim] Create an new instance that bridging 'Target' to SQLite records.
        /// This initializer is used to specify 'Target' type in type parameter by your self.
        public init() {
            
        }
        
        /// [Swim] Create an new instance that translating
        /// - Parameter target: The type for translating; this initializer is used for type inference.
        public init(_ target: Target.Type) {
            
        }
    }
}

extension SQLite3.Translator {
 
    public static var allFields: [SQLite3.Field] {
    
        return Target.sqlite3Columns.map(\.field)
    }
    
    public static var tableName: String {
        
        return Target.sqlite3TableName
    }
    
    public static var quotedTableName: String {
        
        return SQLite3.quotedFieldName(tableName)
    }
    
    public static func sqliteField(by name: String) -> SQLite3.Field {
        
        guard let column = Target.sqlite3Columns.first(where: { $0.field.name == name }) else {

            fatalError("Specified name '\(name)' is not defined in 'sqlite3Columns'.")
        }
        
        return column.field
    }
    
    public static func sqliteField(of keyPath: PartialKeyPath<Target>) -> SQLite3.Field {
        
        guard let column = Target.sqlite3Columns.first(where: { $0.bindingTo?.keyPath == keyPath }) else {

            fatalError("Specified key path is not defined in 'sqlite3Columns'.")
        }
        
        return column.field
    }
    
    public static var primaryKeys: Array<Column> {
        
        return Target.sqlite3ColumnsForDecleration.filter(\.primaryKey)
    }
    
    @CommaSeparatedList
    public static var declaresSQL: String {
        
        let primaryKeys = self.primaryKeys

        if primaryKeys.count > 1 {

            Target.sqlite3ColumnsForDecleration.map { $0.declareSQL(markAsPrimaryKey: false) }

            if !primaryKeys.isEmpty {

                "PRIMARY KEY \(SQLite3.enclosedList(primaryKeys.map(\.field.quotedName)))"
            }
        }
        else {

            Target.sqlite3ColumnsForDecleration.map { $0.declareSQL(markAsPrimaryKey: primaryKeys.contains($0)) }
        }
    }
    
    @CommaSeparatedList
    public static var fieldsSQLForSelection: String {
        
        Target.sqlite3ColumnsForSelection.map(\.field.sql)
    }
    
    @CommaSeparatedList
    public static var fieldsSQLForInsertion: String {
        
        Target.sqlite3ColumnsForInsertion.map(\.field.sql)
    }
    
    public static func valueSQL(for column: Column, value: Target) -> String {
        
        guard let bindingTo = column.bindingTo else {
        
            fatalError("The column named '\(column.field.fieldName)' is not binding to any properties.")
        }
        
        let value = value[keyPath: bindingTo.keyPath]
        
        switch (bindingTo.datatype, bindingTo.nullable) {
        
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
    
    public static func valuesSQL(of value: Target) -> String {
        
        let values = Target.sqlite3Columns.map { valueSQL(for: $0, value: value) }
        
        return SQLite3.listedText(values)
    }
    
    public static func valuesSQLForInsertion(of value: Target) -> String {
        
        let values = Target.sqlite3ColumnsForInsertion.map { valueSQL(for: $0, value: value) }
        
        return SQLite3.listedText(values)
    }

    public func makeCreateTableSQL() -> SQLWithNoConditions {
    
        return .createTable(Target.self)
    }
    
    public func makeDropTableSQL() -> SQLWithNoConditions {
        
        return .dropTable(Target.self)
    }
    
    public func makeCreateIndexSQLs() -> [SQLWithNoConditions] {
    
        return SQLite3.SQL.createIndexes(for: Target.self)
    }
    
    public func makeBeginTransactionSQL() -> SQLWithNoConditions {
    
        return .beginTransaction(on: Target.self)
    }
    
    public func makeCommitTransactionSQL() -> SQLWithNoConditions {
        
        return .commitTransaction(on: Target.self)
    }
    
    public func makeRollbackTransactionSQL() -> SQLWithNoConditions {
        
        return .rollbackTransaction(on: Target.self)
    }

    public func makeSelectSQL() -> SQLWithNoConditions {
    
        return makeSelectSQL(fields: [], orderBy: [])
    }
    
    public func makeSelectSQL(fields: [SQLite3.Field]) -> SQLWithNoConditions {
        
        return makeSelectSQL(fields: fields, orderBy: [])
    }
    
    public func makeSelectSQL(orderBy: [String]) -> SQLWithNoConditions {
        
        return makeSelectSQL(fields: [], orderBy: orderBy)
    }
        
    public func makeSelectSQL(fields: [SQLite3.Field], orderBy: [String]) -> SQLWithNoConditions {
        
        return .select(fields, from: Target.self, orderBy: orderBy)
    }
    
    public func makeInsertSQL(with value: Target) -> SQLWithNoConditions {
        
        return .insert(value)
    }
    
    public func makeReplaceSQL(with value: Target) -> SQLWithNoConditions {
        
        return .replace(value)
    }
    
    public func makeDeleteSQL() -> SQLWithNoConditions {
        
        return .delete(from: Target.self)
    }
    
    public func makeVacuumSQL() -> SQLWithNoConditions {
        
        return .vacuum()
    }

    public func makeSelectSQL(where conditions: Conditions) -> SQLWithConditions {
        
        return makeSelectSQL(fields: [], where: conditions, orderBy: [])
    }
    
    public func makeSelectSQL(fields: [SQLite3.Field], where conditions: Conditions) -> SQLWithConditions {
        
        return makeSelectSQL(fields: fields, where: conditions, orderBy: [])
    }
    
    public func makeSelectSQL(where conditions: Conditions, orderBy: [String]) -> SQLWithConditions {
        
        return makeSelectSQL(fields: [], where: conditions, orderBy: orderBy)
    }
    
    public func makeSelectSQL(fields: [SQLite3.Field], where conditions: Conditions, orderBy: [String]) -> SQLWithConditions {

        return .select(fields, from: Target.self, where: conditions, orderBy: orderBy)
    }
    
    public func makeInsertSQL(_ value: Target, where conditions: Conditions) -> SQLWithConditions {
        
        return .insert(value, where: conditions)
    }

    public func makeReplaceSQL(_ value: Target, where conditions: Conditions) -> SQLWithConditions {
        
        return .replace(value, where: conditions)
    }

    public func makeDeleteSQL(from table: Target.Type, where conditions: SQLite3.Conditions<Target>) -> SQLWithConditions {
        
        return .delete(from: Target.self, where: conditions)
    }
    
    public func instantiate(from statement: SQLite3.Statement) -> Target {
    
        return instantiate(from: statement.row)
    }
    
    public func instantiate(from row: SQLite3.Row) -> Target {
        
        let metadata = Target.sqlite3ColumnsForDecleration
        
        guard row.count == metadata.count else {
        
            fatalError("Expect the number of columns (\(row.count)) is equals to the number of metadata (\(metadata.count)).")
        }
        
        let propertyWriter = UnsafeDynamicPropertyWriter<Target>(initialValue: Target.sqlite3DefaultValue)
        
        for (column, metadata) in zip(row, metadata) {

            guard let bindingTo = metadata.bindingTo, column.declaredType == bindingTo.datatype else {

                fatalError("Type mismatch. Type of column '\(column.name)' is \(column.declaredType), but type of property '\(metadata.field)' is \(metadata.bindingTo?.datatype.description ?? "unspecified").")
            }
            
            switch (bindingTo.datatype, bindingTo.nullable) {
            
            case (.variant, false):
                try! propertyWriter.write(column.value, to: bindingTo.keyPath)

            case (.variant, true):
                try! propertyWriter.write(column.value, to: bindingTo.keyPath)

            case (.integer, false):
                try! propertyWriter.write(column.integerValue!, to: bindingTo.keyPath)

            case (.integer, true):
                try! propertyWriter.write(column.integerValue, to: bindingTo.keyPath)

            case (.real, false):
                try! propertyWriter.write(column.realValue!, to: bindingTo.keyPath)

            case (.real, true):
                try! propertyWriter.write(column.realValue, to: bindingTo.keyPath)

            case (.text, false):
                try! propertyWriter.write(column.textValue!, to: bindingTo.keyPath)
                
            case (.text, true):
                try! propertyWriter.write(column.textValue, to: bindingTo.keyPath)
            }
        }
        
        return propertyWriter.value
    }
}
