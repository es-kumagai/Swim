//
//  FunctionMatch.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2021/02/17.
//

/// [Swim] Returns a Boolean value that returned by `function` given `value`.
/// - Parameters:
///   - pattern: A function that applying to `value`.
///   - value: A value that is given to `function`.
/// - Returns: The return value by `function` with `value`.
@inlinable public func ~= <T>(pattern: (T) -> Bool, value: T) -> Bool {

    return pattern(value)
}
