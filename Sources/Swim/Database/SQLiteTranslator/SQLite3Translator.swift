//
//  SQLite3Translator.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/23.
//

extension SQLite3 {
    
    public struct Translator<Target> where Target : SQLite3Translateable {
        
        public private(set) var tableName: String
        public private(set) var metadata: Array<Metadata>

        public init(tableName: String? = nil) throws {

            self.tableName = SQLite3.fieldName(tableName ?? "\(Target.self)")
            self.metadata = Target.sqlite3Columns
        }
    }
}

extension SQLite3.Translator {
 
    public typealias ConditionsPredicate = () -> Condition
    
    public func makeCreateTableSQL() -> String {
        
        let columns = metadata.map(\.sql)
        
        return "CREATE TABLE \(tableName) (\(columns.joined(separator: ", ")))"
    }

    public func makeSelectSQL(where conditions: ConditionsPredicate? = nil) -> String {

        let statement = "SELECT * FROM \(tableName)"

        if let conditionSQL = conditions?().sql {

            return statement + " WHERE \(conditionSQL)"
        }
        else {

            return statement
        }
    }

    public func makeDeleteSQL(where conditions: SQLite3.Translator<Target>.Condition? = nil) -> String {

        let statement = "DELETE FROM \(tableName)"

        if let conditionSQL = conditions?.sql {

            return statement + " WHERE \(conditionSQL)"
        }
        else {

            return statement
        }
    }

    public func makeInsertSQL(for value: Target) -> String {
        
        let fields = metadata.map(\.name).map(SQLite3.fieldName)
        let values = metadata.map { meta -> String in
            
            let value = value[keyPath: meta.keyPath]
            
            switch (meta.datatype, meta.nullable) {

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
                 return (value as? String).map(SQLite3.quoted) ?? "NULL"
                
            case (.text, false):
                return SQLite3.quoted(value as! String)
            }
        }
        
        return "INSERT INTO \(tableName) (\(fields.joined(separator: ", "))) VALUES (\(values.joined(separator: ", ")))"
    }
    
    public func instantiate(from statement: SQLite3.Statement) -> Target {
    
        return instantiate(from: statement.row)
    }
    
    public func instantiate(from row: SQLite3.Row) -> Target {
        
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
