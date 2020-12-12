//
//  SQLiteSequence.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/12.
//

public struct SQLiteSequence<Element> where Element : SQLite3Translateable {
    
    public typealias Filter = SQLite3.Conditions<Element>
    public typealias Translator = SQLite3.Translator<Element>
    
    private var sqlite: SQLite3
    private var translator: SQLite3.Translator<Element>
}

extension SQLiteSequence {
    
    public init() throws {
        
        sqlite = try! SQLite3(store: .onMemory, options: .readwrite)
        translator = Translator()
        
        try sqlite.execute(translator.makeCreateTableSQL())
        
        for sql in translator.makeCreateIndexSQLs() {
            
            try sqlite.execute(sql: sql.description)
        }
    }

    public func filtered(by filter: Filter?) -> SQLiteFilteredSequence<Element> {

        return SQLiteFilteredSequence<Element>(sequence: self, filter: filter)
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

extension SQLiteSequence : Sequence {

    public func makeIterator() -> some IteratorProtocol {
    
        return makeIterator(with: nil, orderBy: [])
    }

    public func makeIterator(with filter: Filter?) -> SQLiteSequenceIterator<Element> {
        
        return makeIterator(with: filter, orderBy: [])
    }
    
    public func makeIterator(orderBy: [SQLite3.Order]) -> SQLiteSequenceIterator<Element> {
        
        return makeIterator(with: nil, orderBy: orderBy)
    }
    
    public func makeIterator(with filter: Filter?, orderBy: [SQLite3.Order]) -> SQLiteSequenceIterator<Element> {
     
        let fields = Translator.allFields
        let sql: String
        
        switch filter {
        
        case .none:
            sql = translator.makeSelectSQL(fields: fields, orderBy: orderBy).text()
            
        case .some(let filter):
            sql = translator.makeSelectSQL(fields: fields, where: filter, orderBy: orderBy).text()
        }
        
        guard let statement = try! sqlite.execute(sql: sql) else {
            
            fatalError("Failed to create a statement with \(sql).")
        }
        
        return SQLiteSequenceIterator(translator: translator, iterator: statement.makeIterator())
    }
}
