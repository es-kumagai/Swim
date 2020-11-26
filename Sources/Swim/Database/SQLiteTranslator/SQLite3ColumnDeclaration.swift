//
//  SQLite3ColumnDeclaration.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/26.
//

extension SQLite3 {

    @_functionBuilder
    public struct ColumnsDeclaration {
        
        public static func buildBlock<Target : SQLite3Translateable>(_ columns: SQLite3.ColumnMetadata<Target> ...) -> Array<SQLite3.ColumnMetadata<Target>> {
            
            return columns
        }
    }
}
