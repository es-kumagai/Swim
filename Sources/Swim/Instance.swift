//
//  Instance.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/01/16.
//

/// [Swim] Applying an expression to given instance.
/// - Parameters:
///   - instance: The instance to applying the given expression.
///   - expression: The expression which apply to given instance.
public func applyingExpression<T>(into instance: inout T, expression: (inout T) throws -> Void) rethrows -> Void {
    
    try expression(&instance)
}

/// [Swim] Applying an expression to given object instance.
/// - Parameters:
///   - instance: The object instance to applying the given expression.
///   - expression: The expression which apply to given instance.
/// - Returns: The instance passed by `instance` itself.
@discardableResult
public func applyingExpression<T: AnyObject>(to instance: T, expression: (T) throws -> Void) rethrows -> T {
    
    try expression(instance)
    
    return instance
}

/// [Swim]
/// - Parameters: Applying an expression to given instance.
///   - instance: The instance to applying the given expression. This parameter allow a new instance just created.
///   - expression: The expression which apply to given instance.
/// - Returns: The instance applied the expression.
public func instanceApplyingExpression<T>(with instance: T, expression: (inout T) throws -> Void) rethrows -> T {

    var instance = instance
    
    try applyingExpression(into: &instance) { instance in
    
        try expression(&instance)
    }
    
    return instance
}
