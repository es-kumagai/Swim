//
//  SQLite3Translator.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/23.
//

extension SQLite3 {
    
    public struct Translator<Type> where Type : SQLite3Translateable {
        
        private(set) var tableName: String
        private(set) var metadata: Array<Metadata>

        public init(tableName: String? = nil) throws {

            self.tableName = SQLite3.fieldName(tableName ?? "\(Type.self)")
            self.metadata = try Self.makeMetadata()
        }
    }
}

private func ~= (pattern: Any.Type, value: Any.Type) -> Bool {
    
    return pattern == value
}

extension SQLite3.Translator {
 
    public func makeCreateTableSQL() -> String {
        
        let columns = metadata.map(\.sql)
        
        return "CREATE TABLE \(tableName) (\(columns.joined(separator: ", ")))"
    }

    public func makeInsertSQL(for value: Type) -> String {
        
        let mirror = Mirror(reflecting: value)
        
        let fields = metadata.map(\.name).map(SQLite3.fieldName)
        let values = zip(mirror.children, metadata).map { (item, meta) -> String in
            
            switch (meta.datatype, type(of: item.value)) {

            case (.integer, Int.self), (.integer, Optional<Int>.self):
                return (item.value as? Int)?.description ?? "NULL"
                
            case (.real, Double.self), (.real, Optional<Double>.self):
                return (item.value as? Double)?.description ?? "NULL"
                
            case (.text, String.self), (.text, Optional<String>.self):
                 return (item.value as? String).map(SQLite3.quoted) ?? "NULL"
                
            case (.null, _):
                return "NULL"
                
            default:
                fatalError("Unexpected data type. (metadata: \(meta.datatype), type of value: \(type(of: item.value))")
            }
        }
        
        return "INSERT INTO \(tableName) (\(fields.joined(separator: ", "))) VALUES (\(values.joined(separator: ", ")))"
    }
    
    public func instantiate(from row: SQLite3.Row) -> Type {
        
        guard row.count == metadata.count else {
        
            fatalError("Expect the number of columns (\(row.count)) is equals to the number of metadata (\(metadata.count)).")
        }
        
        let dataLength = MemoryLayout<Type>.size
        let dataBytes = UnsafeMutableBufferPointer<Int8>.allocate(capacity: dataLength)
        
        let rawBytes = UnsafeMutableRawBufferPointer(dataBytes)
        
        defer {
        
            dataBytes.deallocate()
        }
        
        for (column, metadata) in zip(row, metadata) {

            guard column.type == metadata.datatype else {

                fatalError("Type mismatch. Type of column '\(column.name)' is \(column.type), but type of property '\(metadata.name)' is \(metadata.datatype).")
            }
            
            switch column.type {
            
            case .integer:
                rawBytes.storeBytes(of: column.integerValue, toByteOffset: metadata.offset, as: Int.self)

            case .real:
                rawBytes.storeBytes(of: column.realValue, toByteOffset: metadata.offset, as: Double.self)

            case .text:
                rawBytes.storeBytes(of: column.textValue, toByteOffset: metadata.offset, as: String.self)
                
            case .null:
                fatalError("Metatype 'null' is not supported.")
            }
        }
        
        return rawBytes.load(as: Type.self)
    }
}

internal extension SQLite3.Translator {
    
    static func makeMetadata() throws -> Array<Metadata> {
        
        let mirror = Type.mirror
        let alignment = Double(MemoryLayout<Self>.alignment)
        
        var offset = 0
        
        return try mirror.children.map { item in
            
            let name = item.label!
            let datatype: SQLite3.DataType
            let nullable: Bool
            let size: Int
                        
            switch type(of: item.value) {
            
            case Int.self:
                datatype = .integer
                nullable = false
                size = MemoryLayout<Int>.size
                
            case Optional<Int>.self:
                datatype = .integer
                nullable = true
                size = MemoryLayout<Int?>.size
                
            case String.self:
                datatype = .text
                nullable = false
                size = MemoryLayout<String>.size
                
            case Optional<String>.self:
                datatype = .text
                nullable = true
                size = MemoryLayout<String?>.size
                
            case Double.self:
                datatype = .real
                nullable = false
                size = MemoryLayout<Double>.size
                
            case Optional<Double>.self:
                datatype = .real
                nullable = true
                size = MemoryLayout<Double?>.size

            case let type:
                throw SQLite3.TranslationError.uncompatibleSwiftType(type)
            }
            
            defer {
                
                offset = Int((Double(offset + size) / alignment).rounded(.up) * alignment)
            }

            return Metadata(name: name, datatype: datatype, nullable: nullable, offset: offset, size: size)
        }
    }
}
