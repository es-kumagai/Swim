//
//  SQLite3TranslatorMetadata.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/23.
//

extension SQLite3 {
    
    public struct ColumnMetadata<Target> where Target : SQLite3Translateable {
        
        public var name: String
        public var keyPath: PartialKeyPath<Target>
        public var datatype: SQLite3.DefineDataType
        public var nullable: Bool
        
        /// [Swim] Create an instance that is analyzed by `keyPath`.
        /// If the `keyPath`'s type is not supported by SQLite3, aborting program in runtime.
        ///
        /// - Parameters:
        ///   - name: The name of this metadata.
        ///   - value: The value that use to analyze metadata.
        ///   - offset: The offset data of this metadata.
        public init<Value>(name: String, keyPath: KeyPath<Target, Value>) {
            
            self.name = name
            self.keyPath = keyPath as PartialKeyPath<Target>
            
            switch Value.self {
            
            case SQLite3.Value.self:
                datatype = .variant
                nullable = false
                
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

private func ~= (pattern: Any.Type, value: Any.Type) -> Bool {

    return pattern == value
}

extension SQLite3.ColumnMetadata {
    
    var offset: Int {
    
        return MemoryLayout<Target>.offset(of: keyPath)!
    }
    
    var declareSQL: String {
        
        let elements = [
            SQLite3.quotedFieldName(name),
            datatype.description,
            (nullable ? "" : "NOT NULL")
        ]
        
        return elements
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}

extension SQLite3.ColumnMetadata : Equatable {
    
}
