//
//  UnsafeSendingObject.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2026/02/24.
//

/// [Swim] A wrapper that allows an object to cross an isolation boundary
/// without being blocked by concurrency safety checks.
///
/// Use this when you intentionally pass a value across an isolation
/// boundary even though it does not conform to `Sendable` despite being
/// concurrency-safe, or when you treat it as `sending` and do not use it
/// afterward.
///
/// The programmer is responsible for guaranteeing that it is actually
/// safe to use across the isolation boundary.
public struct UnsafeSendingObject<Wrapped: AnyObject>: @unchecked Sendable, ~Copyable {
    public let value: Wrapped
    
    public init(_ value: consuming Wrapped) {
        self.value = value
    }
}
