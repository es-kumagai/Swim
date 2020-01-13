//
//  WeakObjectContainer.swift
//  Swim
//
//  Created by Tomohiro Kumagai on H27/05/06.
//
//

public final class WeakObjectContainer<T: AnyObject> {
    
    public typealias EqualityPredicate = (T, T) -> Bool
    
    public fileprivate(set) weak var object: T?
    public fileprivate(set) var equal: EqualityPredicate
    
    public convenience init(_ object: T?) {
        
        self.init(object, equal: ===)
    }
    
    public init(_ object: T?, equal: @escaping EqualityPredicate) {
        
        self.object = object
        self.equal = equal
    }
    
    public var isObjectReleased: Bool {
        
        object == nil
    }
    
    public var hasObject: Bool {
        
        object != nil
    }
    
    public func hasObject(_ object: T) -> Bool {
        
        guard !isObjectReleased else {
            
            return false
        }
        
        return equal(self.object!, object)
    }
}
