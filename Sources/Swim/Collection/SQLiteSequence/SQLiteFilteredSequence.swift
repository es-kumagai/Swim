//
//  SQLiteFilteredSequence.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/08.
//

public struct SQLiteFilteredSequence<Element> where Element : SQLite3Translateable {
    
    public typealias Filter = SQLiteSequence<Element>.Filter
    
    private var sequence: SQLiteSequence<Element>
    private var filter: Filter?
    
    internal init(sequence: SQLiteSequence<Element>, filter: Filter?) {
        
        self.sequence = sequence
        self.filter = filter
    }
}

extension SQLiteFilteredSequence {
    
    public func filtered(by filter: Filter? = nil, operator: (Filter?, Filter?) -> Filter? = (&)) -> Self {

        return Self.init(sequence: sequence, filter: `operator`(self.filter, filter))
    }
    
    public func ordered(by fields: String ...) -> SQLiteSequenceIterator<Element> {
        
        return ordered(by: fields)
    }

    public func ordered(by fields: [String]) -> SQLiteSequenceIterator<Element> {
        
        return sequence.makeIterator(with: filter, orderBy: fields)
    }
    
    public func ordered(by fields: [SQLite3.Field]) -> SQLiteSequenceIterator<Element> {
        
        return ordered(by: fields.map(\.fieldName))
    }
}

extension SQLiteFilteredSequence : Sequence {
    
    public func makeIterator() -> some IteratorProtocol {

        return sequence.makeIterator(with: filter)
    }
}
