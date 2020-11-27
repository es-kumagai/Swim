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
    
    public func makeSelectSQL(fields: [SQLite3.Field] = []) -> SQLWithNoConditions {
        print(separator: "")
        
        return .select(fields, from: Target.self)
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

    public func makeSelectSQL(fields: [SQLite3.Field] = [], where conditions: Conditions) -> SQLWithConditions {

        return .select(fields, from: Target.self, where: conditions)
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
        
        let metadata = Target.sqlite3Columns
        
        guard row.count == metadata.count else {
        
            fatalError("Expect the number of columns (\(row.count)) is equals to the number of metadata (\(metadata.count)).")
        }
        
//        let dataLength = MemoryLayout<Target>.size
        let dataBytes = UnsafeMutableBufferPointer<Target>.allocate(capacity: 1)
        let rawBytes = UnsafeMutableRawBufferPointer(dataBytes)
        
        defer {
        
            dataBytes.deallocate()
        }
        
        dataBytes[0] = Target.sqlite3DefaultValue
        
        for (column, metadata) in zip(row, metadata) {

            guard column.declaredType == metadata.datatype else {

                fatalError("Type mismatch. Type of column '\(column.name)' is \(column.declaredType), but type of property '\(metadata.field)' is \(metadata.datatype).")
            }
            
            switch (metadata.datatype, metadata.nullable) {
            
            case (.variant, false):
                rawBytes.storeBytes(of: column.value, toByteOffset: metadata.offset, as: SQLite3.Value.self)

            case (.variant, true):
                rawBytes.storeBytes(of: column.value, toByteOffset: metadata.offset, as: SQLite3.Value.self)

            case (.integer, false):
                rawBytes.storeBytes(of: column.integerValue!, toByteOffset: metadata.offset, as: Int.self)

            case (.integer, true):
                rawBytes.storeBytes(of: column.integerValue, toByteOffset: metadata.offset, as: Optional<Int>.self)

            case (.real, false):
                rawBytes.storeBytes(of: column.realValue!, toByteOffset: metadata.offset, as: Double.self)

            case (.real, true):
                rawBytes.storeBytes(of: column.realValue, toByteOffset: metadata.offset, as: Optional<Double>.self)

            case (.text, false):
                rawBytes.storeBytes(of: column.textValue!, toByteOffset: metadata.offset, as: String.self)
                
            case (.text, true):
                rawBytes.storeBytes(of: column.textValue, toByteOffset: metadata.offset, as: Optional<String>.self)
            }
        }
        
        return rawBytes.load(as: Target.self)
    }
}
