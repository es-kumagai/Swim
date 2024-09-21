//
//  Optional.swift
//  Swim
//  
//  Created by Tomohiro Kumagai on 2024/09/21
//  
//

/// [Swim] Returns a `nil` value of the specified `type`.
///
/// This function provides a convenient way to obtain a `nil` value for a given type.
/// It can be useful in situations where you need a placeholder or a default `nil` value for generic type.
///
/// - Parameter type: The type for which to return a `nil` value.
///                   This parameter is used only to specify the type and does not affect the returned value.
/// - Returns: A `nil` value of the specified type `T`.
///
/// Example:
/// ```
/// let stringValue: (some StringProtocol)? = nilValue(for: String.self) // stringValue will be nil
/// let intValue: (some BinaryInteger)? = nilValue(for: Int.self)         // intValue will be nil
public func nilValue<T>(for type: T.Type) -> T? {
    nil
}
