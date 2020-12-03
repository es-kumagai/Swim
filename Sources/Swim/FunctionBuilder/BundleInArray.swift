//
//  BundleInArray.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/03.
//

@_functionBuilder
public struct BundleInArray {
    
    public static func buildBlock<T>(_ components: T ...) -> [T] {
        
        return components
    }
}
