//
//  ErrorHandling.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2026/02/24.
//

/// [Swim] Executes an asynchronous throwing operation and propagates its error.
///
/// Use this overload when you want to preserve the original error type `E` from `body`.
///
/// - Parameters:
///   - body: An asynchronous operation that may throw an error of type `E` and returns `T`.
/// - Returns: The value returned by `body`.
/// - Throws: Re-throws the same error `E` that `body` throws.
///
/// - SeeAlso: ``withErrorHandling(_:mapError:)``
public func withErrorHandling<T, E>(_ body: () async throws(E) -> sending T) async throws(E) -> sending T where E: Error {
    try await body()
}

/// [Swim] Executes a synchronous throwing operation and propagates its error.
///
/// - Parameters:
///   - body: A synchronous operation that may throw an error of type `E` and returns `T`.
/// - Returns: The value returned by `body`.
/// - Throws: Re-throws the same error `E` that `body` throws.
///
/// - SeeAlso: ``withErrorHandling(_:mapError:)``
public func withErrorHandling<T, E>(_ body: () throws(E) -> sending T) throws(E) -> sending T where E: Error {
    try body()
}

/// [Swim] Executes an asynchronous operation and maps its error from type `E` to `F` when it fails.
///
/// On success, the result of `body` is returned unchanged. On failure, the caught error `E` is
/// transformed by `mapError` into an error of type `F`, which is then thrown.
///
/// - Parameters:
///   - body: An asynchronous operation that may throw an error of type `E` and returns `T`.
///   - mapError: An asynchronous transformer that converts `E` into `F`.
/// - Returns: The value returned by `body`.
/// - Throws: The transformed error of type `F`.
///
/// - Example:
/// ```swift
/// enum NetworkError: Error { case offline }
/// enum AppError: Error { case network }
/// let value = try await withErrorHandling({ () async throws(NetworkError) -> Int in
///     throw .offline
/// }, mapError: { (error: NetworkError) async -> AppError in
///     .network
/// })
/// ```
public func withErrorHandling<T, E, F>(rethrows _: F.Type = F.self,  _ body: () async throws(E) -> sending T, mapError: (_ error: E) async -> F) async throws(F) -> sending T where E: Error, F: Error {
    return try await withErrorHandling(body) { error throws(F) in
        throw await mapError(error)
    }
}

/// [Swim] Executes a synchronous operation and maps its error from type `E` to `F` when it fails.
///
/// - Parameters:
///   - body: A synchronous operation that may throw an error of type `E` and returns `T`.
///   - mapError: A transformer that converts `E` into `F`.
/// - Returns: The value returned by `body`.
/// - Throws: The transformed error of type `F`.
///
/// - Tip: Use this to normalize errors from existing APIs into your app's domain-specific error type.
public func withErrorHandling<T, E, F>(rethrows _: F.Type = F.self, _ body: () throws(E) -> sending T, mapError: (_ error: E) -> F) throws(F) -> sending T where E: Error, F: Error {
    return try withErrorHandling(body) { error throws(F) in
        throw mapError(error)
    }
}

public func withErrorHandling<T, E, F>(rethrows _: F.Type = F.self, _ body: () throws(E) -> sending T, onError: (_ error: E) throws(F) -> T) throws(F) -> sending T where E: Error, F: Error {
    do {
        return try body()
    } catch {
        return try onError(error)
    }
}

public func withErrorHandling<T, E, F>(rethrows _: F.Type = F.self, _ body: () async throws(E) -> sending T, onError: (_ error: E) async throws(F) -> T) async throws(F) -> sending T where E: Error, F: Error {
    do {
        return try await body()
    } catch {
        return try await onError(error)
    }
}
