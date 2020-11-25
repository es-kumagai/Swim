//
//  SQLite3Translateable.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/23.
//

public protocol SQLite3Translateable {
    
    static var sqlite3Columns: Array<SQLite3.Translator<Self>.Metadata> { get }
}

extension SQLite3Translateable {
    
    public static func sqliteName(of keyPath: PartialKeyPath<Self>) -> String {
        
        guard let column = sqlite3Columns.first(where: { $0.keyPath == keyPath }) else {

            fatalError("Specified key path is not defined in 'sqlite3Columns'.")
        }
        
        return column.name
    }
}
