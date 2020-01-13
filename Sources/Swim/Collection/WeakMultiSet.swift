//
//  WeakMultiSet.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/01/13.
//

/**!
This is a multi set that has elements as weak reference.
If an element is released, this element will remove from the multi set.

The multi set treats element which type is AnyObject. Each elements are comparing with Self.Equal function.
The Self.Equal function is assigned `===` by default. If you want to compare using Equatable, you must set `==` to Self.Equal at the initialization.
**/
public struct WeakMultiSet<Element: AnyObject> {

    typealias Container = WeakObjectContainer<Element>
    typealias Containers = ContiguousArray<Container>
    
    public typealias EqualityPredicate = (Element, Element) -> Bool
    
    public fileprivate(set) var equal: EqualityPredicate
    
    fileprivate var _containers: Containers
    
    /// Construct an empty Array
    public init() {

        self.init(equal: ===)
    }

    /// Construct from an arbitrary sequence with elements of type `T`
    public init<S: Sequence>(_ sequence: S) where Element == S.Iterator.Element {

        self.init(equal: ===, sequence: sequence)
    }
    
    /// Construct an empty Array
    public init(equal: @escaping EqualityPredicate) {

        self._containers = Containers()
        self.equal = equal
    }
    
    /// Construct from an arbitrary sequence with elements of type `T`
    public init<S: Sequence>(equal: @escaping EqualityPredicate, sequence:S) where Element == S.Iterator.Element {
        
        let containers = sequence.map { Container($0, equal: equal) }
        
        self._containers = Containers(containers)
        self.equal = equal
    }
    
    /// Get count of valid elements.
    public var count: Int {
        
        return _validContainerIndexes.count
    }
    
    /// Get count of same elements.
    public func count(of element:Element) -> Int {

        let indexes = _containers.indexes {
            
            $0.hasObject(element)
        }
        
        return indexes.count
    }
    
    /// Returns a boolean value whether the sequence has no valid elements.
    public var isEmpty:Bool {

        self.count == 0
    }
    
    /// Get first element.
    public var first: Element? {
    
        self._validContainerIndexes.first.flatMap {
            
            _containers[$0].object
        }
    }
    
    /// Get first element.
    public var last: Element? {
        
        return self._validContainerIndexes.last.flatMap {

            _containers[$0].object
        }
    }
    
    /// Add an element to head.
    public mutating func appendFirst(_ element:Element) {
        
        let container = Container(element, equal: self.equal)
        
        _compress()
        _containers.insert(container, at:0)
    }
    
    /// Add an element to tail.
    public mutating func appendLast(_ element:Element) {

        let container = Container(element, equal: self.equal)
        
        _compress()
        _containers.append(container)
    }
    
    /// Return a boolean value whether the instance contains the `element`.
    public func contains(_ element:Element) -> Bool {

        _containers.meetsAny {

            $0.hasObject(element)
        }
    }
    
    /// Returns elements same as `element`. If `element` is not found, returns empty array.
    public func findAll(_ element: Element) -> [Element] {

        let indexes = _containers.indexes {

            $0.hasObject(element)
        }
        
        return indexes.map {

            _containers[$0].object!
        }
    }
    
    /// Remove one of the elements. This method seek from head.
    public mutating func removeOneFromFirst(_ element:Element) {
        
         _removeOneFromFirst(element, atIndexes: _validContainerIndexes) {
            
            $0.hasObject(element)
        }
    }
    
    /// Remove one of the elements. This method seek from tail.
    public mutating func removeOneFromLast(_ element:Element) {
        
        _removeOneFromFirst(element, atIndexes: _validContainerIndexes.reversed()) {
            
            $0.hasObject(element)
        }
    }
    
    /// Remove all of the elements.
    public mutating func removeAll(_ element:Element) {

        let indexes = _containers.indexes {
            
            $0.hasObject(element)
        }
        
        _containers.remove(contentsAt: indexes)
    }
    
    /// Remove all elements.
    public mutating func removeAll() {
        
        _containers.removeAll(keepingCapacity: false)
    }
    
    /// Remove first valid element.
    @discardableResult
    public mutating func removeFirst() -> Element? {
        
        _compress()
        
        guard !_containers.isEmpty else {
            
            return nil
        }
            
        return _containers.remove(at: 0).object
    }
    
    /// Remove last valid element.
    @discardableResult
    public mutating func removeLast() -> Element? {
        
        _compress()
        
        guard !_containers.isEmpty else {

            return nil
        }
        
        return _containers.removeLast().object
    }
}

open class WeakMultiSetGenerator<Element: AnyObject> : IteratorProtocol {

    typealias Containers = WeakMultiSet<Element>.Containers
    typealias Index = Containers.Index
    typealias Indexes = Array<Index>

    fileprivate var containers:Containers

    var indexes:Indexes
    var indexGenerator:Indexes.Iterator

    init(_ sequence:WeakMultiSet<Element>) {

        containers = sequence._containers
        indexes = containers.indexes {
            
            !$0.isObjectReleased
        }
        
        indexGenerator = indexes.makeIterator()
    }

    open func next() -> Element? {
        
        if let index = indexGenerator.next() {
            
            let container = containers[index]
            
            return container.object
        }
        else {
            
            return nil
        }
    }
}

extension WeakMultiSet {
    
    /// Remove one of the element from `indexes`. This method seek from head of `indexes`.
    fileprivate mutating func _removeOneFromFirst(_ element:Element, atIndexes indexes:[Int], predicate: (Container)->Bool) {
        
        let found = indexes.firstIndex {
            
            _containers[$0].hasObject(element)
        }
        
        if let found = found {
            
            _containers.remove(at: indexes[found])
        }
    }
    
    /// Get indexes for valid containers.
    fileprivate var _invalidContainerIndexes:[Int] {
        
        _containers.indexes {
            
            $0.isObjectReleased
        }
    }

    /// Get indexes for released containers.
    fileprivate var _validContainerIndexes:[Int] {
        
        _containers.indexes {
            
            !$0.isObjectReleased
        }
    }
    
    /// Remove released element containers.
    fileprivate mutating func _compress() {
        
        _containers.remove(contentsAt: _invalidContainerIndexes)
    }
}

extension WeakMultiSet : ExpressibleByArrayLiteral {

    public init(arrayLiteral elements: Element...) {
        
        self.init(elements)
    }
}

extension WeakMultiSet : Sequence {

    public func makeIterator() -> WeakMultiSetGenerator<Element> {
        
        WeakMultiSetGenerator<Element>(self)
    }
}
