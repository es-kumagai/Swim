//
//  TypeMatch.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/08.
//

/// [Swim] Returns a Boolean value indicating whether both `pattern` and `value` is the same type.
/// - Parameters:
///   - pattern: A metatype.
///   - value: A value to match against `pattern`.
/// - Returns: True iff the type that passed by `value` is equal to `pattern`, otherwise false.
@inlinable public func ~= (pattern: Any.Type, value: Any.Type) -> Bool {

    return pattern == value
}
