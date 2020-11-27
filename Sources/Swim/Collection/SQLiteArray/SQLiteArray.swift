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
        translator = SQLite3.Translator<Element>()
        
        let sql = translator.makeCreateTableSQL()
        try sqlite.execute(sql: sql.description)
        
        for sql in translator.makeCreateIndexSQLs() {
            
            try sqlite.execute(sql: sql.description)
        }
    }
}

extension SQLiteArray {
    
    public func insert(_ element: Element) {
        
        do {

            let sql = translator.makeInsertSQL(with: element)
            try sqlite.execute(sql: sql.description)
        }
        catch {
            
            fatalError("Failed to insert. \(error)")
        }
    }
}

extension SQLiteArray {
    
    public var count: Int {
        
        let sql = translator.makeSelectSQL(fields: [.init("*", function: "COUNT")])
        
        do {

            guard let statement = try sqlite.execute(sql: sql.description) else {
            
                fatalError("Failed to get count.")
            }
            
            return statement.row.first!.integerValue!
        }
        catch {
        
            fatalError("\(error)")
        }
    }
}
