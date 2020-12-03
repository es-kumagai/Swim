//
//  SQLiteArray.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/12.
//

public struct SQLiteArray<Element> where Element : SQLite3Translateable {
    
    public typealias Filter = SQLite3.Conditions<Element>
    
    private var sqlite: SQLite3
    private var translator: SQLite3.Translator<Element>
    
    public var filter: Filter?
    
    public init(filter: Filter? = nil) throws {
        
        sqlite = try! SQLite3(store: .onMemory, options: .readwrite)
        translator = SQLite3.Translator<Element>()
        
        self.filter = filter
        
        try sqlite.execute(translator.makeCreateTableSQL())
        
        for sql in translator.makeCreateIndexSQLs() {
            
            try sqlite.execute(sql: sql.description)
        }
    }
}

extension SQLiteArray {
    
    public func enumerated(with filter: Filter? = nil) -> SQLiteArraySequence<Element> {

        let sql: String
            
        switch filter {
        
        case .none:
            sql = translator.makeSelectSQL().text()
            
        case .some(let filter):
            sql = translator.makeSelectSQL(where: filter).text()
        }
        
        guard let statement = try! sqlite.execute(sql: sql) else {
            
            fatalError("Failed to create a statement with \(sql).")
        }
        
        return SQLiteArraySequence(translator: translator, iterator: statement.makeIterator())
    }

    public mutating func append(_ element: Element) {
        
        do {

            try sqlite.execute {

                translator.makeInsertSQL(with: element)
            }
        }
        catch {
            
            fatalError("Failed to insert. \(error)")
        }
    }
    
    public mutating func removeAll() {
        
        do {

            try sqlite.execute {
                
                translator.makeBeginTransactionSQL()
                translator.makeDeleteSQL()
                translator.makeVacuumSQL()
                translator.makeCommitTransactionSQL()
            }
        }
        catch {
            
            try! sqlite.execute {

                translator.makeRollbackTransactionSQL()
            }
            
            fatalError("\(error)")
        }
    }
    
    public var count: Int {
        
        let sql = translator.makeSelectSQL(fields: [.init("*", function: "COUNT")])
        
        do {

            guard let statement = try sqlite.execute(sql) else {
            
                fatalError("Failed to get count.")
            }
            
            return statement.row.first!.integerValue!
        }
        catch {
        
            fatalError("\(error)")
        }
    }
}

extension SQLiteArray : Sequence {
    
    public func makeIterator() -> some IteratorProtocol {
     
        return enumerated(with: filter)
    }
}
