//
//  SQLite3Columns.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/11.
//

extension SQLite3 {
    
    @dynamicMemberLookup
    public final class Columns {

        internal private(set) unowned var db: SQLite3
        internal private(set) unowned var statement: Statement
        
        internal init(db: SQLite3, statement: Statement) {
            
            self.db = db
            self.statement = statement
        }
        
        public subscript<Index : BinaryInteger>(index: Index) -> Column {
            
            return SQLite3.Column(statement: statement, index: index)
        }
        
        public subscript(name: String) -> Column {
            
            guard let columnIndex = statement.columnNames.firstIndex(of: name) else {
                
                fatalError("Column `\(name)` is not found.")
            }
            
            return self[columnIndex]
        }
 
        public subscript (dynamicMember name: String) -> SQLite3.Column {

            return self[name]
        }
    }
}

extension SQLite3.Columns : Collection {

    public func index(after i: Int) -> Int {
        
        return i + 1
    }
        
    public var startIndex: Int {
        
        return 0
    }
    
    public var endIndex: Int {
        
        return statement.columnCount
    }
    
    public subscript (index: Int) -> SQLite3.Column {
        
        return SQLite3.Column(statement: statement, index: index)
    }
}
