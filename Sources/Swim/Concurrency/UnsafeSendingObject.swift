//
//  UnsafeSendingObject.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2026/02/24.
//

/// [Swim] A wrapper that allows an object to cross an isolation boundary
/// without being blocked by concurrency safety checks.
@available(*, unavailable, renamed: "UnsafeSending")
public struct UnsafeSendingObject: Sendable {}

/// [Swim] A wrapper that allows an instance to cross an isolation boundary
/// without being blocked by concurrency safety checks.
///
/// Use this when you intentionally pass a value across an isolation
/// boundary even though it does not conform to `Sendable` despite being
/// concurrency-safe, or when you treat it as `sending` and do not use it
/// afterward.
///
/// The programmer is responsible for guaranteeing that it is actually
/// safe to use across the isolation boundary.
public struct UnsafeSending<Wrapped>: @unchecked Sendable where Wrapped: SendableMetatype {
    public let value: Wrapped
    
    public init(_ value: consuming Wrapped) {
        self.value = value
    }
}

extension UnsafeSending: CustomStringConvertible where Wrapped: CustomStringConvertible {
    
    public var description: String {
        value.description
    }
}

extension UnsafeSending: CustomDebugStringConvertible where Wrapped: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        "Unsafe Sending: \(value.debugDescription)"
    }
}

extension UnsafeSending: Equatable where Wrapped: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

extension UnsafeSending: Hashable where Wrapped: Hashable {
    public func hash(into hasher: inout Hasher) {
        value.hash(into: &hasher)
    }
}

extension UnsafeSending: Comparable where Wrapped: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}
