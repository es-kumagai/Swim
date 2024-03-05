//
//  CSVContentsConvertible.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/03/05
//  
//

public protocol CSVContentsConvertible : Sequence {
    
    associatedtype CSVColumn : CaseIterable & RawRepresentable<String>

    static var csv: CSV { get }
    
    func csvColumns(for column: CSVColumn, item: Element) -> String
}

public extension CSVContentsConvertible {
    
    static var csv: CSV { .standard }
    
    static var csvHeaderLine: String {
        
        CSVColumn
            .allCases
            .map(\.rawValue)
            .map(csv.quoted(_:))
            .joined(separator: String(csv.separator))
    }
    
    func csvContentLine(for item: Element) -> String {
        
        flatMap { item in
            
            CSVColumn.allCases.map { column in
                csvColumns(for: column, item: item)
            }
        }
        .map(Self.csv.quoted(_:))
        .joined(separator: String(Self.csv.separator))
    }
    
    var csvContents: String {
        
        @BundleInArray<String>
        var contents: [String] {
            Self.csvHeaderLine
            map(csvContentLine(for:))
        }
        
        return contents.joined(separator: "\n")
    }
}
