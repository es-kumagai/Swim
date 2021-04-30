//
//  SQLite3IndexDeclaration.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/27.
//

extension SQLite3 {

    @resultBuilder
    public struct IndexDeclaration {
        
        public static func buildBlock<Target : SQLite3Translateable>(_ indexes: SQLite3.Index<Target> ...) -> Array<SQLite3.Index<Target>> {
            
            return indexes
        }
    }
}
