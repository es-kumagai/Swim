//
//  CheckedTypedThrowingContinuation.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2026/02/24.
//

/// [Swim] A wrapper around `CheckedContinuation` that constrains the error type in a type-safe way.
///
/// Internally holds a `CheckedContinuation<T, any Error>`, while exposing a public API
/// that restricts the error type to the generic `E`. This prevents unintended error types
/// from leaking through when resuming the continuation and makes the contract between
/// the caller and the implementation explicit.
///
/// - Generics:
///   - `T`: The value type ultimately produced by the continuation.
///   - `E`: The error type that can be thrown. Must conform to `Error`.
public struct CheckedTypedThrowingContinuation<T, E>: Sendable where E: Error {
    private let rawContinuation: CheckedContinuation<T, any Error>
    
    /// Creates a typed wrapper from a raw `CheckedContinuation<T, any Error>`.
    ///
    /// - Parameters:
    ///   - continuation: The underlying `CheckedContinuation<T, any Error>`.
    ///   - errorType: A placeholder parameter used only to convey the error type `E` (its value is not used).
    public init(_ continuation: CheckedContinuation<T, any Error>, errorType _: E.Type) {
        rawContinuation = continuation
    }
    
    /// Resumes the continuation by returning a successful value.
    ///
    /// - Parameter value: The value to return.
    public func resume(returning value: sending T) {
        rawContinuation.resume(returning: value)
    }
    
    /// Resumes the continuation by throwing an error.
    ///
    /// - Parameter error: The error to throw. Constrained to type `E`.
    public func resume(throwing error: E) {
        rawContinuation.resume(throwing: error)
    }
    
    /// Resumes the continuation with a `Result`.
    ///
    /// - Parameter result: A result that represents either success or failure.
    public func resume(with result: sending Result<T, E>) {
        rawContinuation.resume(with: result)
    }
}

@inlinable
/// [Swim] This function calls the standard `withCheckedThrowingContinuation` under the hood and
/// passes a `CheckedTypedThrowingContinuation<T, E>` to `body`. It lets you explicitly
/// fix the error type when bridging callback-based APIs to async/await.
///
/// - Generics:
///   - `T`: The value type produced by the asynchronous operation.
///   - `E`: The error type that can be thrown.
/// - Parameters:
///   - _: The metatype of the error `E` you want to fix.
///   - isolation: The actor isolation to use (defaults to the caller's isolation).
///   - function: The caller's function name (defaults to `#function`).
///   - body: A closure that receives a `CheckedTypedThrowingContinuation<T, E>` and decides
///           when and how to resume the continuation.
/// - Returns: The value produced by the asynchronous operation.
/// - Throws: An error of type `E`.
public func withCheckedThrowingContinuation<T, E>(_: E.Type, isolation: isolated (any Actor)? = #isolation, function: String = #function, _ body: (CheckedTypedThrowingContinuation<T, E>) -> Void) async throws(E) -> sending T where E: Error {
    do {
        return try await withCheckedThrowingContinuation { continuation in
            body(CheckedTypedThrowingContinuation(continuation, errorType: E.self))
        }
    } catch let error as E {
        throw error
    } catch {
        fatalError("Internal Error: Unexpected error was thrown: \(error)")
    }
}
