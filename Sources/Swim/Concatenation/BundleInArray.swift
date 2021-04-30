//
//  BundleInArray.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/03.
//

/// A result builder to concatenate some arrays and some elements into an array.
@resultBuilder
public struct BundleInArray<T> {

    public static func buildExpression(_ expression: T) -> Array<T> {
        
        return [expression]
    }
    
    public static func buildExpression(_ expression: T?) -> Array<T> {
        
        switch expression {
        
        case .some(let value):
            return [value]
            
        case .none:
            return []
        }
    }
    
    public static func buildExpression(_ expression: Array<T>) -> Array<T> {
        
        return expression
    }
    
    public static func buildBlock(_ components: Array<T>...) -> Array<T> {
        
        return components.reduce([], +)
    }
    
    public static func buildEither(first component: Array<T>) -> Array<T> {
        
        return component
    }
    
    public static func buildEither(second component: Array<T>) -> Array<T> {
        
        return component
    }
    
    public static func buildOptional(_ component: Array<T>?) -> Array<T> {
        
        return component ?? []
    }
    
    public static func buildArray(_ components: [Array<T>]) -> Array<T> {
        
        return components.reduce([], +)
    }
}

extension Array {
    
    /// [Swim] Concatenate some arrays and some elements to a single array.
    /// - Parameter predicate: A function to concatenate some arrays and some elements.
    /// - Returns: An array that concatenate given arrays and elements.
    public static func bundle(@BundleInArray<Element> _ predicate: () throws -> Self) rethrows -> Self {
        
        return try predicate()
    }
}
