//
//  CSVLineConvertible.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/09.
//

public protocol CSVLineConvertible {
    
    typealias CSVColumn = CSV.Column<Self>
    
    static var csvColumns: [CSVColumn] { get }
    static var csvDefaultValue: Self { get }
    
    init(_ value: Self)
}

extension CSV {

    @resultBuilder
    public struct ColumnDeclaration {
        
        public static func buildBlock<Target : CSVLineConvertible>(_ components: Column<Target> ...) -> [Column<Target>] {
            
            return components
        }
    }
}

extension CSVLineConvertible {
    
    public init(csvLine: String) throws {
        
        let csvColumns = Self.csvColumns
        let dataColumns = CSV.split(CSV.removedTrailingNewline(of: csvLine))
        
        guard dataColumns.count == csvColumns.count else {
            
            throw CSV.ConversionError.columnsMismatch(line: csvLine, columns: csvColumns.map(CSV.AnyColumn.init))
        }

        let propertyWriter = UnsafeDynamicPropertyWriter(initialValue: Self.csvDefaultValue)
        
        for (data, meta) in zip(dataColumns, csvColumns) {
        
            guard let value = meta.datatype.init(csvDescription: data) else {
                
                throw CSV.ConversionError.invalidValue(data, to: meta.datatype)
            }
            
            do {
                
                switch (meta.datatype.csvDataType, meta.datatype.csvNullable) {
                
                case (.integer, false):
                    try propertyWriter.write(value as! Int, to: meta.keyPath)

                case (.integer, true):
                    try propertyWriter.write(value as? Int, to: meta.keyPath)

                case (.floatingPoint, false):
                    try propertyWriter.write(value as! Double, to: meta.keyPath)

                case (.floatingPoint, true):
                    try propertyWriter.write(value as? Double, to: meta.keyPath)

                case (.string, false):
                    try propertyWriter.write(value as! String, to: meta.keyPath)

                case (.string, true):
                    try propertyWriter.write(value as? String, to: meta.keyPath)
                }
            }
            catch let error as UnsafeDynamicPropertyWriter<Self>.WriteError {
                
                switch error {
                
                case .invalidKeyPath:
                    throw CSV.ConversionError.unknownKeyPath(CSV.AnyColumn(meta))
                    
                case .typeMismatch(value: let value, property: let property):
                    throw CSV.ConversionError.typeMismatch(value: value, property: property)
                }
            }
            catch {
                
                throw CSV.ConversionError.unexpected(error)
            }
        }
        
        self.init(propertyWriter.value)
    }
    
    public func toCSVLine() -> String {
        
        return Self.csvColumns
            .map { self[keyPath: $0.keyPath] as! CSVColumnConvertible }
            .map(\.csvDescription)
            .joined(separator: ",") + "\n"
    }
    
    public static var csvHeaderLine: String {
        
        return csvColumns
            .map { CSV.quoted($0.name) }
            .joined(separator: ",") + "\n"
    }
}
