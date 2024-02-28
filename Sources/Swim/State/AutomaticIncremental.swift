//
//  AutomaticIncremental.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/02/28
//  
//

@propertyWrapper
public final class AutomaticIncremental<Value> where Value : Strideable {
    
    private var value: Value
    private var initialValue: Value
    private var lockCount: Int
    
    public var wrappedValue: Value {
        
        get {
            defer {
                if !locked {
                    value = value.advanced(by: 1)
                }                
            }
            return value
        }
        
        set {
            value = newValue
        }
    }
    
    public var projectedValue: AutomaticIncremental {
        self
    }
    
    public init(wrappedValue value: Value) {
        self.value = value
        self.initialValue = value
        self.lockCount = 0
    }
    
    public func rewind() {
        value = initialValue
    }
    
    public var locked: Bool {
        lockCount > 0
    }
    
    public func lock() {
        lockCount += 1
    }
    
    public func unlock() {
        lockCount -= 1
    }
}
