//
//  FunctionMatch.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2021/02/17.
//

/// [Swim] Returns a Boolean value that returned by `functionPattern` with `value`.
/// - Parameters:
///   - functionPattern: A function that applying to `value`.
///   - value: A value that is given to `function`.
/// - Returns: A value returned by calling `function` with `value`.
@inlinable
public func ~= <Value>(functionPattern: (Value) -> Bool, value: Value) -> Bool {
    functionPattern(value)
}

/// [Swim] Returns a Boolean value that returned by a value accessing by `keyPathPattern` by `target`.
/// - Parameters:
///   - keyPathPattern: A key path to accessing a property of the `target`.
///   - target: An instance that will be accessed.
/// - Returns: A value returned by accessing the property using `functionPattern` of the `target`.
@inlinable
public func ~= <Target>(keyPathPattern: KeyPath<Target, Bool>, target: Target) -> Bool {
    target[keyPath: keyPathPattern]
}
