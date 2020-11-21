//
//  SQLiteArray.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/12.
//

public protocol SQLiteArrayElement {
    
    /// Create instance with empty data.
    init()
}

private func ~= (pattern: Any.Type, value: Any.Type) -> Bool {
    
    return pattern == value
}

public struct SQLiteArray<Element> where Element : SQLiteArrayElement {
    
    private var sqlite: SQLite3
    private(set) var metadata: Array<ColumnMetadata>
    
    public init() throws {
        
        sqlite = try! SQLite3(store: .onMemory, options: .readwrite)
        metadata = try! Self.makeColumnsMetadata()
        
        let sql = sqlForCreateTable()
        
        try sqlite.execute(sql: sql)
    }
}

extension SQLiteArray {
    
    public enum ConversionError : Error {
        
        case uncompatibleSwiftType(Any.Type)
    }
}

extension SQLiteArray {
    
    public var count: Int {
        
        let sql = "SELECT COUNT(*) FROM \(tableName)"
        
        do {

            guard let statement = try sqlite.execute(sql: sql) else {
            
                fatalError("Failed to get count.")
            }
            
            return statement.columns.first!.integerValue
        }
        catch {
        
            fatalError("\(error)")
        }
    }
}

internal extension SQLiteArray {
    
    var tableName: String {
        
        return SQLite3.fieldName("\(Element.self)")
    }
    
    static func makeColumnsMetadata() throws -> Array<ColumnMetadata> {
        
        let mirror = Mirror(reflecting: Element())
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
                throw ConversionError.uncompatibleSwiftType(type)
            }
            
            defer {
                
                offset = Int((Double(offset + size) / alignment).rounded(.up) * alignment)
            }

            return ColumnMetadata(name: name, datatype: datatype, nullable: nullable, offset: offset, size: size)
        }
    }
    
    func sqlForCreateTable() -> String {
        
        let columns = metadata.map(\.sql)
        
        return "CREATE TABLE \(tableName) (\(columns.joined(separator: ", ")))"
    }
    
    func instantiate(columns: SQLite3.Columns) {
        
        guard columns.count == metadata.count else {
        
            fatalError("Expect the number of columns (\(columns.count)) is equals to the number of metadata (\(metadata.count)).")
        }
        
        let dataLength = MemoryLayout<Element>.size
        let dataBytes = UnsafeMutableBufferPointer<Int8>.allocate(capacity: dataLength)
        
        defer {
        
            dataBytes.deallocate()
        }
        
        for (column, metadata) in zip(columns, metadata) {

//            guard column.type == metadata.datatype else {
//                
//            }
            
        }
    }
}
