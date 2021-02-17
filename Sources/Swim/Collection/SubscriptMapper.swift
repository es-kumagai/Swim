//
//  SubscriptMapper.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2021/02/18.
//

/// [Swim] A type that provide a feature of accessing something using subscript.
/// The target values of collection are kept by closure which is held by this instance.
public struct SubscriptMapper<T, Index> {

    private var getter: (Index) -> T

    public init(_ getter: @escaping (Index) -> T) {
        
        self.getter = getter
    }
 
    public subscript (index: Index) -> T {
        
        return getter(index)
    }
}

extension SubscriptMapper where T : ExpressibleByNilLiteral {
    
    public init() {
        
        self.init { _ in nil }
    }
}
