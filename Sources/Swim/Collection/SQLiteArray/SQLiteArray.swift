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
        
        let sql = "SELECT COUNT(*) AS count FROM \(tableName)"
        
        do {

            guard let statement = try sqlite.execute(sql: sql) else {
            
                fatalError("Failed to get count.")
            }
            
            return statement.columns.count.integerValue
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
        
        return try mirror.children.map { item in
            
            let name = item.label!
            let datatype: SQLite3.DataType
            let nullable: Bool
            
            switch type(of: item.value) {
            
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

            case let type:
                throw ConversionError.uncompatibleSwiftType(type)
            }
            
            return ColumnMetadata(name: name, datatype: datatype, nullable: nullable)
        }
    }
    
    func sqlForCreateTable() -> String {
        
        let columns = metadata.map(\.sql)
        
        return "CREATE TABLE \(tableName) (\(columns.joined(separator: ", ")))"
    }
}
