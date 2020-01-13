//
//  Traverse.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/01/13.
//

extension Sequence {
    
    /**
    [Swim] Processing each value of `domain` with `predicate` in order.
    If predicate returns .Abort, abort processing and return .Aborted.
    If you want index of element, use this function with enumerate(sequence) as `S`.
    :return: .Passed if all elements processed, otherwise .Aborted.
    */
    @discardableResult
    public func traverse(_ predicate: (Element) -> Continuous) -> ProcessExitStatus {
        
        for element in self {
            
            if predicate(element) == .abort {
                
                return .aborted(in: -1)
            }
        }
        
        return .passed
    }
    
    /**
    [Swim] Processing each value of `domain` with `predicate` in order.
    If predicate returns non-nil value, abort processing and return the result value.
    :return: result of `predicate` if `predicate` results non-nil value, otherwise nil.
    */
    public func traverse<R>(_ predicate: (Element) -> R?) -> R? {
        
        for element in self {
            
            if let result = predicate(element) {
                
                return result
            }
        }
        
        return nil
    }

    /// [Swim] Returns a Boolean value that indicates whether all of `values` meets the `predicate`.
    public func meetsAll(predicate: (Element) -> Bool) -> Bool {
        
        let meets = traverse {
            
            predicate($0) ? .continue : .abort
        }
        
        return meets.passed
    }
    
    /// [Swim] Returns a Boolean value that indicates whether any of `values` meets the `predicate`.
    public func meetsAny(predicate: (Element) -> Bool) -> Bool {
        
        let meets = traverse {
            
            predicate($0) ? .abort : .continue
        }
        
        return meets.aborted
    }
    
    /// [Swim] Returns a Boolean value that indicates whether none of `values` meets the `predicate`.
    public func meetsNone(predicate: (Element) -> Bool) -> Bool {
        
        let meets = traverse {
            
            predicate($0) ? .abort : .continue
        }
        
        return meets.passed
    }
}

extension Sequence where Element : Equatable {

    /// [Swim] Returns a Boolean value that indicates whether all of `values` meets the `predicate`.
    public func meetsAll(of element: Element) -> Bool {
        
        return meetsAll { $0 == element }
    }
    
    /// [Swim] Returns a Boolean value that indicates whether any of `values` meets the `predicate`.
    public func meetsAny(of element: Element) -> Bool {
        
        return meetsAny { $0 == element }
    }
    
    /// [Swim] Returns a Boolean value that indicates whether none of `values` meets the `predicate`.
    public func meetsNone(of element: Element) -> Bool {
        
        return meetsNone { $0 == element }
    }
}
