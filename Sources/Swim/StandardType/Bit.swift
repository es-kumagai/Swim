//
//  Bit.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/03/26
//  
//

/// [Swim] Represents a single binary digit, which can be either 0 or 1.
///
/// `Bit` is an enumeration used to represent a single bit, which is the basic unit of
/// information in computing and digital communications. The enumeration defines two possible
/// states, `zero` and `one`, corresponding to the binary values 0 and 1, respectively.
public enum Bit : Int {
    
    case zero = 0
    case one = 1
}

public extension Bit {
    
    /// [Swim] Initialize a bit with `value`.
    /// - Parameter value: A boolean value to initialize the bit, where `true` is 1 and `false` is 0.
    init(_ value: Bool) {
        self = value ? .one : .zero
    }
    
    /// [Swim] A Boolean value indicating whether the bit is set.
    var isSet: Bool {
        
        switch self {

        case .zero:
            return false
            
        case .one:
            return true
        }
    }
    
    /// [Swim] Returns the logical NOT of the given `bit`.
    ///
    /// This prefix operator takes a single Bit instance and inverts its value.
    /// For example, if the bit represents `1`, the result will be a bit representing `0`, and vice versa.
    ///
    /// - Parameter bit: A `Bit` instance to negate.
    /// - Returns: The negated `Bit` instance.
    static prefix func ! (bit: Bit) -> Bit {
        ~bit
    }
    
    /// [Swim] Returns the bitwise complement of the given bit.
    ///
    /// This prefix operator takes a single Bit instance and performs a bitwise NOT operation,
    /// flipping the bit value. For example, if the bit represents `1`, the result will be a bit
    /// representing `0`, and if the bit represents `0`, the result will be a bit representing `1`.
    ///
    /// - Parameter bit: A Bit instance to invert.
    /// - Returns: The bitwise complement of the given Bit instance.
    static prefix func ~ (bit: Bit) -> Bit {
        
        switch bit {
            
        case .zero:
            return .one
            
        case .one:
            return .zero
        }
    }
}

extension Bit : Hashable, Codable, Sendable {
    
}

extension Bit : ExpressibleByBooleanLiteral {
    
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
}

extension Bit : LosslessStringConvertible {
    
    public init?(_ description: String) {
        
        switch description {
            
        case "0":
            self.init(false)
            
        case "1":
            self.init(true)
            
        default:
            return nil
        }
    }
    
    public var description: String {
            
            switch self {
                
            case .zero:
                return "0"
                
            case .one:
                return "1"
            }
    }
}

public extension Bool {
    
    /// [Swim] Creates a Boolean value from a Bit instance, converting the `bit`'s state to a Boolean value.
    ///
    /// Use this initializer to convert a `Bit` instance into a corresponding `Bool` value,
    /// where the bit's set state translates to `true` and its unset state to `false`.
    /// This conversion allows for seamless interaction between custom bit representations
    /// and standard Boolean logic.
    ///
    /// - Parameter bit: The `Bit` instance to be converted into a Boolean value.
    init(_ bit: Bit) {
            
        switch bit {
            
        case .zero:
            self = false
            
        case .one:
            self = true
        }
    }
}

public extension BinaryInteger {
    
    init(_ bit: Bit) {
        self = numericCast(bit.rawValue)
    }
}
