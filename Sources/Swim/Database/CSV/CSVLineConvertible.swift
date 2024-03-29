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
    
    public init(csvLine: some StringProtocol, using csv: CSV = .standard, columnCountValidation: Bool = true) throws {
        
        let csvColumns = Self.csvColumns
        let dataColumns = csv.split(csv.removedTrailingNewline(of: csvLine))
        
        guard !columnCountValidation || dataColumns.count == csvColumns.count else {
            
            throw CSV.ConversionError.columnsMismatch(line: String(csvLine), columns: csvColumns.map(CSV.AnyColumn.init))
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
            
            guard meta.datatype.unsafeWrite(csvDescription: data, to: resultPointer, offset: offset) else {
                
                throw CSV.ConversionError.invalidValue(data, to: meta.datatype)
            }
        }
        
        self.init(resultBuffer.pointee)
    }
    
    public func toCSVLine(using csv: CSV = .standard) -> String {
        
        return Self.csvColumns
            .map { self[keyPath: $0.keyPath] as! CSVColumnConvertible }
            .map { $0.csvDescription(with: csv) }
            .joined(separator: ",") + "\n"
    }
    
    public static func csvHeaderLine(with csv: CSV = .standard) -> String {
        
        return csvColumns
            .map { csv.quoted($0.name) }
            .joined(separator: ",") + "\n"
    }
}
