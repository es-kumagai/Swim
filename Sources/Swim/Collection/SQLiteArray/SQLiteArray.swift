//
//  SQLiteArray.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/12.
//

public struct SQLiteArray<Element> where Element : SQLite3Translateable {
    
    private var sqlite: SQLite3
    private var translator: SQLite3.Translator<Element>
    
    public init() throws {
        
        sqlite = try! SQLite3(store: .onMemory, options: .readwrite)
        translator = try! SQLite3.Translator<Element>()
        
        let sql = translator.makeCreateTableSQL()
        
        try sqlite.execute(sql: sql)
    }
}

extension SQLiteArray {
    
    public func insert(_ element: Element) {
        
        do {

            try sqlite.execute(sql: translator.makeInsertSQL(for: element))
        }
        catch {
            
            fatalError("Failed to insert. \(error)")
        }
    }
}

extension SQLiteArray {
    
    public var count: Int {
        
        let sql = "SELECT COUNT(*) FROM \(translator.tableName)"
        
        do {

            guard let statement = try sqlite.execute(sql: sql) else {
            
                fatalError("Failed to get count.")
            }
            
            return statement.row.first!.integerValue
        }
        catch {
        
            fatalError("\(error)")
        }
    }
}
