//
//  SQLite3TranslatorMetadata.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/23.
//

extension SQLite3.Translator {
    
    public struct Metadata {
        
        public var name: String
        public var datatype: SQLite3.DefineDataType
        public var nullable: Bool
        public var offset: Int
        public var size: Int
    }
}

private func ~= (pattern: Any.Type, value: Any.Type) -> Bool {

    return pattern == value
}

extension SQLite3.Translator.Metadata {
    
    var sql: String {
        
        let elements = [
            SQLite3.fieldName(name),
            datatype.description,
            (nullable ? "" : "NOT NULL")
        ]
        
        return elements
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    /// [Swim] Create an instance analyzed from `value`.
    /// If the `value` is not supported by SQLite3, returns nil.
    ///
    /// - Parameters:
    ///   - name: The name of this metadata.
    ///   - value: The value that use to analyze metadata.
    ///   - offset: The offset data of this metadata.
    init?(name: String, value: Any, offset: Int) {
        
        let datatype: SQLite3.DefineDataType
        let nullable: Bool
        let size: Int
                    
        switch type(of: value) {
        
        case SQLite3.Value.self:
            datatype = .variant
            nullable = false
            size = MemoryLayout<SQLite3.Value>.size
            
        case Optional<SQLite3.Value>.self:
            datatype = .variant
            nullable = true
            size = MemoryLayout<SQLite3.Value?>.size
            
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

        default:
            return nil
        }

        self.init(name: name, datatype: datatype, nullable: nullable, offset: offset, size: size)
    }
}

extension SQLite3.Translator.Metadata : Equatable {
    
}
