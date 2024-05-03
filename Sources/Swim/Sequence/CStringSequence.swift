//
//  CStringSequence.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/05/03
//  
//

public struct CStringSequence<Characters> : Sequence where Characters : Sequence, Characters.Element == UInt8 {
    
    private let characters: Characters
    private var terminated = false
    
    public init(characters: Characters) {
        self.characters = characters
    }
    
    public func makeIterator() -> CharacterIterator<Characters.Iterator> {
        CharacterIterator(characters)
    }
}

extension CStringSequence where Characters == [UInt8] {
    
    public init(_ characters: some Sequence<Byte>) {
        self.characters = characters.map(UInt8.init)
    }
    
    public init(_ text: some StringProtocol) {
        
        characters = text.withCString { (address: consuming UnsafePointer) in
            
            var characters = [UInt8]()
            
            while address.pointee != 0 {
                
                characters.append(UInt8(bitPattern: address.pointee))
                address += 1
            }
            
            return characters
        }
    }
}

extension CStringSequence {
    
    public struct CharacterIterator<Iterator> : IteratorProtocol where Iterator : IteratorProtocol {
        
        private var iterator: Characters.Iterator
        private var terminated = false
        
        init(_ characters: Characters) {
            iterator = characters.makeIterator()
        }
        
        public mutating func next() -> UInt8? {
            
            guard !terminated else {
                return nil
            }
            
            switch iterator.next() {
                
            case 0, nil:
                terminated = true
                return 0

            case let character:
                return character
            }
        }
    }
}
