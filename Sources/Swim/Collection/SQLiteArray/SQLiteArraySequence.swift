//
//  SQLiteArrayIterator.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/04.
//

public struct SQLiteArraySequence<Target> where Target : SQLite3Translateable {
    
    internal private(set) var translator: SQLite3.Translator<Target>
    internal private(set) var iterator: SQLite3.StatementIterator
    
    internal init(translator: SQLite3.Translator<Target>, iterator: SQLite3.StatementIterator) {
        
        self.translator = translator
        self.iterator = iterator
    }
}

extension SQLiteArraySequence : IteratorProtocol, Sequence {

    public mutating func next() -> Target? {
        
        guard let element = iterator.next() else {
            
            return nil
        }
        
        return translator.instantiate(from: element)
    }
}
