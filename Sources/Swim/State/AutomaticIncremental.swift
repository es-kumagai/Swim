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
    
    public var wrappedValue: Value {
        
        get {
            defer {
                value = value.advanced(by: 1)
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
    }
    
    public func rewind() {
        value = initialValue
    }
}
