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

    internal init(_ getter: @escaping (Index) -> T) {
        
        self.getter = getter
    }
 
    subscript (index: Index) -> T {
        
        return getter(index)
    }
}
