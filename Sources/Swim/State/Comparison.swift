//
//  Comparison.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/01/13.
//

/// [Swim] Compare the size of `lhs` and `rhs`.
///
/// - Parameters:
///   - lhs: A first value to be compared.
///   - rhs: A second value to be compared.
/// - Returns: The result of comparing `lhs` and `rhs`.
public func compare<T : Comparable>(_ lhs: T, _ rhs: T) -> Comparison {

    if lhs == rhs {
        
        return .same
    }
    else {
        
        return lhs < rhs ? .ascending : .descending
    }
}

/**
[Swim] A Type that means comparison state of two values.
The type can convert from SignedIntegerType.

    value == 0:    .Same
    value < 0:    .Ascending
    value > 0:    .Descending
**/
public enum Comparison {
    
    /// It means same order.
    case same
    
    /// This means less than other.
    case ascending
    
    /// This means greater than other.
    case descending
    
    /// [Swim] Creates an instance represented by a signed number.
    ///
    /// The initializer representing by following rule.
    ///
    ///        A positive number:    -> .ascending
    ///        A negative number:    -> .descending
    ///        zero:                -> .same
    ///
    /// - parameter number: A number using representing.
    public init<N>(representedBy number: N) where N : SignedInteger {
        
        switch number {
            
        case 0:
            self = .same
            
        case let value where value > 0:
            self = .ascending
            
        case let value where value < 0:
            self = .descending

        default:
            fatalError("Reached to unexpected program path.")
        }
    }
    
    /// [Swim] Returns a boolean value that indicates whether the instance means same ordered.
    public var isSame: Bool {
        
        self ~= .same
    }
    
    /// [Swim] Returns a boolean value that indicates whether the instance means ascending ordered.
    public var isAscending: Bool {
      
        self ~= .ascending
    }
    
    /// [Swim] Returns a boolean value that indicates whether the instance means descending ordered.
    public var isDescending: Bool {
        
        self ~= .descending
    }
    
    /// [Swim] Returns a boolean value that indicates whether the instance means ascending ordered or same ordered.
    public var isAscendingOrSame: Bool {
        
        switch self {
        
        case .same, .ascending:
            return true
            
        case .descending:
            return false
        }
    }
    
    /// [Swim] Returns a boolean value that indicates whether the instance means descending ordered or same ordered.
    public var isDescendingOrSame: Bool {
        
        switch self {
        
        case .same, .descending:
            return true
            
        case .ascending:
            return false
        }
    }
}
