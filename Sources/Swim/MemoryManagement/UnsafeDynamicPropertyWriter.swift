//
//  UnsafeDynamicPropertyWriter.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/09.
//

public final class UnsafeDynamicPropertyWriter<Target> {
    
    private let pointer: UnsafeMutablePointer<Target>
    
    public enum WriteError : Error {
    
        case invalidKeyPath(PartialKeyPath<Target>)
        case typeMismatch(value: Any.Type, property: Any.Type)
    }
    
    public init(initialValue: Target) {
    
        pointer = .allocate(capacity: 1)
        pointer.initialize(to: initialValue)
    }
    
    deinit {
        
        pointer.deinitialize(count: 1)
        pointer.deallocate()
    }
    
    public var value: Target {
        
        return pointer.pointee
    }
    
    public func write<Value>(_ value: Value, to keyPath: PartialKeyPath<Target>) throws {

        let valueType = type(of: value)
        let propertyType = type(of: pointer.pointee[keyPath: keyPath])
        
        guard valueType == propertyType else {
            
            throw WriteError.typeMismatch(value: valueType, property: propertyType)
        }
        
        guard let offset = MemoryLayout<Target>.offset(of: keyPath) else {
            
            throw WriteError.invalidKeyPath(keyPath)
        }
        
        let pointer = UnsafeMutableRawPointer(self.pointer)
        
        pointer.storeBytes(of: value, toByteOffset: offset, as: Value.self)
    }
    
    public func write<Value : CSVColumnConvertible>(_ value: Value, to keyPath: KeyPath<Target, Value>) throws {

        guard let offset = MemoryLayout<Target>.offset(of: keyPath) else {
            
            throw WriteError.invalidKeyPath(keyPath)
        }
        
        let pointer = UnsafeMutableRawPointer(self.pointer)
        
        pointer.storeBytes(of: value, toByteOffset: offset, as: Value.self)
    }
}
