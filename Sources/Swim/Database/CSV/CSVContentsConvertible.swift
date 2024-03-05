//
//  CSVContentsConvertible.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/03/05
//  
//

public protocol CSVContentsConvertible {
    
    associatedtype CSVColumn : CaseIterable & RawRepresentable<String>
    associatedtype CSVContentItem
    associatedtype CSVContentItems : Sequence<CSVContentItem>
    
    static var csv: CSV { get }
    
    var csvContentItems: CSVContentItems { get }
    
    func csvColumnValue(for column: CSVColumn, item: CSVContentItem) -> String
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
    
    func csvContentLine(for item: CSVContentItem) -> String {
        
        CSVColumn.allCases.map { column in
            csvColumnValue(for: column, item: item)
        }
        .joined(separator: String(Self.csv.separator))
    }
    
    var csvContentsDescription: String {
        csvContentsDescription(includesHeaderLine: true)
    }
     
    func csvContentsDescription(includesHeaderLine: Bool) -> String {
        
        @BundleInArray<String>
        var contents: [String] {
            
            if (includesHeaderLine) {
                Self.csvHeaderLine
            }
            
            csvContentItems.map(csvContentLine(for:))
        }
        
        return contents.joined(separator: "\n")
    }
}
