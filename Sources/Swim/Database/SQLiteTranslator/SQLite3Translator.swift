//
//  SQLite3Translator.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/23.
//

extension SQLite3 {
    
    public struct Translator<Target> where Target : SQLite3Translateable {
                
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
 
    public func makeCreateTableSQL() -> SQLite3.SQL<Target, SQLite3.NoConditions> {
    
        return .createTable(Target.self)
    }
    
    public func makeSelectSQL() -> SQLite3.SQL<Target, SQLite3.NoConditions> {
        
        return .select(from: Target.self)
    }
    
    public func makeInsertSQL(with value: Target) -> SQLite3.SQL<Target, SQLite3.NoConditions> {
        
        return .insert(value)
    }
    
    public func makeDeleteSQL() -> SQLite3.SQL<Target, SQLite3.NoConditions> {
        
        return .delete(from: Target.self)
    }

    public func makeSelectSQL(where conditions: SQLite3.Condition<Target>) -> SQLite3.SQL<Target, SQLite3.WithConditions> {

        return .select(from: Target.self, where: conditions)
    }
    
    public func makeInsertSQL(_ value: Target, where conditions: SQLite3.Condition<Target>) -> SQLite3.SQL<Target, SQLite3.WithConditions> {
        
        return .insert(value, where: conditions)
    }
    
    public func makeDeleteSQL(from table: Target.Type, where conditions: SQLite3.Condition<Target>) -> SQLite3.SQL<Target, SQLite3.WithConditions> {
        
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
        
        let dataLength = MemoryLayout<Target>.size
        let dataBytes = UnsafeMutableBufferPointer<Int8>.allocate(capacity: dataLength)
        
        let rawBytes = UnsafeMutableRawBufferPointer(dataBytes)
        
        defer {
        
            dataBytes.deallocate()
        }
        
        for (column, metadata) in zip(row, metadata) {

            guard column.declaredType == metadata.datatype else {

                fatalError("Type mismatch. Type of column '\(column.name)' is \(column.declaredType), but type of property '\(metadata.name)' is \(metadata.datatype).")
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
