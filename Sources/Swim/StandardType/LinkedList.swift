//
//  LinkedList.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 1/8/18.
//

public struct LinkedList<T> {

    public enum Direction {
    
        case top
        case bottom
    }
    
    public class Node<T> {
        
        public fileprivate(set) var element: T
        public fileprivate(set) var previous: Node?
        public fileprivate(set) var next: Node?
        
        fileprivate init(element: T, previous: Node?, next: Node?) {
            
            self.element = element
            self.previous = previous
            self.next = next
        }
    }
    
    public private(set) var firstNode: Node<T>? {
    
        didSet {
            
            if lastNode == nil {
                
                lastNode = firstNode
            }
        }
    }
    
    public private(set) var lastNode: Node<T>? {
        
        didSet {
            
            if firstNode == nil {
                
                firstNode = lastNode
            }
        }
    }

    public init() {
        
        firstNode = nil
        lastNode = nil
    }
}

extension LinkedList {
    
    public init<S: Sequence>(_ elements: S) where S.Element == T {
        
        elements.forEach {
            
            append($0, to: .bottom)
        }
    }
    
    public mutating func append(_ element: T, to direction: Direction) {
        
        let newNode = Node(element: element, previous: nil, next: nil)

        switch direction {
            
        case .bottom:
            
            newNode.previous = lastNode
            lastNode?.next = newNode
            lastNode = newNode

        case .top:

            newNode.next = firstNode
            firstNode?.previous = newNode
            firstNode = newNode
        }
    }
    
    public mutating func insert(_ element: T, at position: Int) {
        
        let node = targetNode(at: position)!
        
        switch node.previous {
            
        case nil:
            append(element, to: .top)
            
        case let previousNode?:
             previousNode.next = Node(element: element, previous: previousNode, next: previousNode.next)
        }
    }
}

extension LinkedList : ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: T...) {
        
        self.init(elements)
    }
}

extension LinkedList : Sequence {
    
    public struct LinkedListIterator<T> : IteratorProtocol {
        
        fileprivate var nextNode: Node<T>?
        
        public mutating func next() -> T? {
            
            defer {
                
                nextNode = nextNode?.next
            }
            
            return nextNode?.element
        }
    }
    
    public func makeIterator() -> LinkedListIterator<T> {
        
        return LinkedListIterator(nextNode: firstNode)
    }
}

extension LinkedList : BidirectionalCollection {
    
    public var first: T? {
    
        return firstNode?.element
    }
    
    public var last: T? {
        
        return lastNode?.element
    }
    
    private func targetNode(at position: Int) -> Node<T>? {
    
        var count = 0
        var targetNode = firstNode
        
        while let node = targetNode {

            if position == count {
                
                return node
            }
            
            count += 1
            targetNode = node.next
        }
        
        return nil
    }
    
    public subscript(position: Int) -> T {
        
        get {

            return targetNode(at: position)!.element
        }
        
        set {
            
            let node = targetNode(at: position)!
            let newNode = Node(element: newValue, previous: node, next: node.next)
            
            node.next = newNode
        }
    }
    
    public var startIndex: Int {
        
        return 0
    }
    
    public var endIndex: Int {
        
        var index = 0
        var currentNode = firstNode
        
        while let node = currentNode {
            
            currentNode = node.next
            index += 1
        }
        
        return index
    }
    

    public func index(after i: Int) -> Int {
        
        return i + 1
    }
    
    
    public func index(before i: Int) -> Int {
        
        return i - 1
    }
}

extension LinkedList where T : Equatable {
    
    static func == (lhs: LinkedList, rhs: LinkedList) -> Bool {
        
        guard lhs.count == rhs.count else {
            
            return false
        }
        
        for (lhs, rhs) in zip(lhs, rhs) {
            
            if lhs != rhs {
                
                return false
            }
        }
        
        return true
    }
}
