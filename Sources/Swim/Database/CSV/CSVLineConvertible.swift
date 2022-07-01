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
        
        
        let resultBuffer = UnsafeMutablePointer<Self>.allocate(capacity: 1)
        let resultPointer = UnsafeMutableRawPointer(resultBuffer)

        resultBuffer.initialize(to: Self.csvDefaultValue)

        defer {
            resultBuffer.deinitialize(count: 1)
            resultBuffer.deallocate()
        }
        
        for (data, meta) in zip(dataColumns, csvColumns) {

            guard let offset = MemoryLayout.offset(of: meta.keyPath) else {
            
                throw CSV.ConversionError.unknownKeyPath(CSV.AnyColumn(meta))
            }
            
            guard meta.datatype.unsafeWrite(csvDescription: data, to: resultPointer + offset) else {
                
                throw CSV.ConversionError.invalidValue(data, to: meta.datatype)
            }
        }
        
        self = resultBuffer.pointee
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
