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

extension SQLite3.Translator {
 
    public func makeCreateTableSQL() -> String {
        
        let columns = metadata.map(\.sql)
        
        return "CREATE TABLE \(tableName) (\(columns.joined(separator: ", ")))"
    }

    public func makeInsertSQL(for value: Type) -> String {
        
        let mirror = Mirror(reflecting: value)
        
        let fields = metadata.map(\.name).map(SQLite3.fieldName)
        let values = zip(mirror.children, metadata).map { (item, meta) -> String in
            
            guard let itemMeta = Metadata(name: item.label!, value: item.value, offset: meta.offset), meta == itemMeta else {
                
                fatalError("Unexpected data type. (metadata: \(meta.datatype), type of value: \(type(of: item.value))")
            }
            
            switch itemMeta.datatype {

            case .integer:
                return (item.value as? Int)?.description ?? "NULL"
                
            case .real:
                return (item.value as? Double)?.description ?? "NULL"
                
            case .text:
                 return (item.value as? String).map(SQLite3.quoted) ?? "NULL"
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

            guard column.declaredType == metadata.datatype else {

                fatalError("Type mismatch. Type of column '\(column.name)' is \(column.declaredType), but type of property '\(metadata.name)' is \(metadata.datatype).")
            }
            
            switch (metadata.datatype, metadata.nullable) {
            
            case (.integer, false):
                rawBytes.storeBytes(of: column.integerValue, toByteOffset: metadata.offset, as: Int.self)

            case (.integer, true):
                rawBytes.storeBytes(of: column.integerValue, toByteOffset: metadata.offset, as: Optional<Int>.self)

            case (.real, false):
                rawBytes.storeBytes(of: column.realValue, toByteOffset: metadata.offset, as: Double.self)

            case (.real, true):
                rawBytes.storeBytes(of: column.realValue, toByteOffset: metadata.offset, as: Optional<Double>.self)

            case (.text, false):
                rawBytes.storeBytes(of: column.textValue, toByteOffset: metadata.offset, as: String.self)
                
            case (.text, true):
                rawBytes.storeBytes(of: column.textValue, toByteOffset: metadata.offset, as: Optional<String>.self)
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
            
            guard let metadata = Metadata(name: item.label!, value: item.value, offset: offset) else {
                
                throw SQLite3.TranslationError.uncompatibleSwiftType(type(of: item.value))
            }

            defer {
                
                offset = Int((Double(offset + metadata.size) / alignment).rounded(.up) * alignment)
            }
            
            return metadata
        }
    }
}
