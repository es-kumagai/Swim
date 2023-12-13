//
//  Sorted.swift
//
//  
//  Created by Tomohiro Kumagai on 2023/12/13
//  
//

@propertyWrapper
public class Sorted<Sequence> where Sequence : SortableSequence {
    
    public typealias Element = Sequence.Element
    public typealias Sorter = (Element, Element) -> Bool
    
    private var sequence: UnsafeMutablePointer<Sequence>
    private var orderedInInternal: Bool
    private let sorter: Sorter
    
    public init(wrappedValue: Sequence = .init(), sorter sortingPredicate: @escaping Sorter) {

        sequence = .allocate(capacity: 1)
        sequence.initialize(to: wrappedValue)

        orderedInInternal = false
        sorter = sortingPredicate
    }
    
    deinit {
        sequence.deinitialize(count: 1)
        sequence.deallocate()
    }
    
    public var wrappedValue: Sequence {
        
        get {
            if !orderedInInternal {
                sort()
            }
            
            return sequence.pointee
        }
        
        set (newContainer) {
            
            sequence.pointee = newContainer
            orderedInInternal = false
        }
    }
    
    public var projectedValue: Sequence {
        
        get {
            sequence.pointee
        }
        
        set {
            sequence.pointee = newValue
        }
    }
}

private extension Sorted {
    
    func sort() {
        sequence.pointee = Sequence(sequence.pointee.sorted(by: sorter))
    }
}

extension Sorted where Sequence.Element : Comparable {
        
    public convenience init(wrappedValue: Sequence = .init()) {
        self.init(wrappedValue: wrappedValue, sorter: <)
    }
}
