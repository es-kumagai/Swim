//
//  SQLite3ColumnsIterator.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/21.
//

extension SQLite3 {
    
    public final class Row {
        
        public private(set) var columns: Columns

        internal init(db: SQLite3, statement: Statement) {
            
            columns = Columns(db: db, statement: statement)
        }

        public subscript<Index : BinaryInteger>(index: Index) -> Column {
            
            return columns[index]
        }
        
        public subscript(name: String) -> Column {
            
            return columns[name]
        }
    }
}

extension SQLite3.Row : Collection {
    
    public func index(after i: Int) -> Int {
        
        return i + 1
    }
        
    public var startIndex: Int {
        
        return 0
    }
    
    public var endIndex: Int {
        
        return columns.statement.columnCount
    }
    
    public subscript (index: Int) -> SQLite3.Column {
        
        return columns[index]
    }
}
