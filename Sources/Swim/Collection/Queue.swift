//
//  Queue.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/01/16.
//

public protocol QueueProtocol : Sequence {
    
    associatedtype Element
    
    /**
    Create an instance that has no elements.
    */
    init()
    
    /**
    Enqueue to the queue.
    :param: element Element to enqueue.
    */
    mutating func enqueue(_ element: Element)
    
    /**
    Dequeue from the queue.
    :return: Element that dequeued. Nil if the queue is empty.
    */
    mutating func dequeue() -> Element?
    
    /**
    Get the front element of the queue.
    */
    var front: Element? { get }

    /**
    Get the back element of the queue.
    */
    var back: Element? { get }
    
    /**
    Returns a Boolean value that indicates whether the queue is empty.
    :return: True if the queue is empty, otherwise false.
    */
    var isEmpty: Bool { get }
    
    /**
    Returns number of elements in the queue.
    :return: Number of elements
    */
    var count: Int { get }
}

extension QueueProtocol {
    
    public var isEmpty: Bool {
        
        return count == 0
    }
}

/// [Swim] An ordered, sequencial-access collection.
public struct Queue<Element> : QueueProtocol, ExpressibleByArrayLiteral {
    
    fileprivate var elements: Array<Element>

    public init() {

        elements = Array<Element>()
    }
    
    public init(arrayLiteral elements: Element...) {
        
        self.elements = elements
    }
    
    public mutating func enqueue(_ element: Element) {
        
        elements.insert(element, at: 0)
    }
    
    public mutating func dequeue() -> Element? {

        guard !isEmpty else {
            
            return nil
        }
        
        return elements.removeLast()
    }
    
    public var front: Element? {
        
        return elements.last
    }
    
    public var back: Element? {
        
        return elements.first
    }
    
    public var isEmpty: Bool {
        
        return elements.isEmpty
    }
    
    public var count: Int {
        
        return elements.count
    }
}

extension Queue : Sequence {
    
    public func makeIterator() -> QueueGenerator<Element> {
        
        return QueueGenerator(self)
    }
}

public struct QueueGenerator<T> : IteratorProtocol {
    
    fileprivate var generator: IndexingIterator<Array<T>>
    
    fileprivate init(_ queue: Queue<T>) {
        
        generator = queue.elements.makeIterator()
    }
    
    public mutating func next() -> T? {
        
        return generator.next()
    }
}

