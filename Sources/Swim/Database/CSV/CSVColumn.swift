//
//  CSVColumn.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/09.
//

extension CSV {
    
    public struct Column<Target> where Target : CSVLineConvertible {
        
        public typealias DataType = CSV.DataType
        public typealias KeyPath = PartialKeyPath<Target>
        
        public var name: String
        public var keyPath: KeyPath
        public var datatype: CSVColumnConvertible.Type
        
        public init<Value>(_ name: String, keyPath: Swift.KeyPath<Target, Value>) where Value : CSVColumnConvertible {
            
            self.name = name
            self.keyPath = keyPath
            self.datatype = Value.self
        }
    }
    
    public struct AnyColumn {
        
        public private(set) var column: CustomDebugStringConvertible
        public private(set) var columnType: Any.Type
        
        public init<Target>(_ column: Column<Target>) where Target : CSVLineConvertible {
            
            self.column = column
            self.columnType = type(of: column)
        }
    }
}

extension CSV.Column : CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        return "\(name): \(datatype)"
    }
}
extension CSV.AnyColumn : CustomDebugStringConvertible {
    
    public var debugDescription: String {

        return column.debugDescription
    }
}
