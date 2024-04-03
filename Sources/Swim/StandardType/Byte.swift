//
//  Byte.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/03/26
//  
//

/// [Swim] A `Byte` represents a single unit of data, equivalent to 8 bits.
public struct Byte {
    
    fileprivate var value: UInt8
    
    public init(_ value: UInt8) {
        self.value = value
    }
}

public extension UInt8 {
    
    /// [Swim] Initializes a `Byte` with the specified `UInt8` value.
    ///
    /// Use this initializer to create a new `Byte` instance from a given `UInt8` value.
    /// This is particularly useful when you need to convert `UInt8` data into `Byte`
    /// for operations that require byte-level data manipulation.
    ///
    /// - Parameter value: The `UInt8` value to be used for initializing the `Byte`.
    init(_ byte: Byte) {
        self = byte.value
    }
}

public extension String {
    
    init(_ byte: Byte) {
        self = byte.hexadecimalDescription
    }
}

extension Byte : Sendable, Hashable, Equatable {
    
}

extension Byte : CustomStringConvertible {
    
    public var description: String {
        hexadecimalDescription
    }
}

extension Byte : CustomDebugStringConvertible {
    
    public var debugDescription: String {
        "\(binaryDescription) (\(hexadecimalDescription))"
    }
}

extension Byte : ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: UInt8) {
        self.value = value
    }
}

private extension Byte {
    
    static func fatalErrorOverflow() {
        fatalError("Bit count must be between 1 to \(bitWidth).")
    }
    
    @inline(__always)
    static func preconditionOverflow(bitPosition n: Int) {
        precondition(bitRange.contains(n), "Bit position must be between 1 to \(bitWidth).")
    }
    
    @inline(__always)
    static func preconditionOverflow(maskBits n: Int) {
        precondition(maskRange.contains(n), "Mask bits must be between 1 to \(bitWidth).")
    }
    
    @inline(__always)
    func fatalErrorOverflow() {
        Self.fatalErrorOverflow()
    }
    
    @inline(__always)
    func preconditionOverflow(bitCount n: Int) {
        Self.preconditionOverflow(bitPosition: n)
    }
    
    @inline(__always)
    func preconditionOverflow(maskBits n: Int) {
        Self.preconditionOverflow(maskBits: n)
    }
}

public extension Byte {
    
    /// [Swim] The number of bits used to represent a `Byte`.
    ///
    /// For a `Byte`, this property always returns 8, as a byte consists of 8 bits.
    var bitWidth: Int {
        Self.bitWidth
    }
    
    /// [Swim] The range of bits represented by a `Byte`.
    ///
    /// This property defines a range starting from the 0th bit up to, but not including,
    /// the bit at the position specified by `bitWidth`. For a `Byte`, which is 8 bits in size,
    /// `bitRange` will effectively encompass the entire byte (0..<8).
    var bitRange: Range<Int> {
        Self.bitRange
    }
    
    /// [Swim] A string representation of the `Byte` in binary format.
    ///
    /// This property provides a convenient way to view the `Byte` value as a binary string.
    var binaryDescription: String {
        
        binaryDescription(withPrefix: "")
    }
    
    /// [Swim] Returns a binary string representation of the `Byte`, optionally prefixed with a specified string.
    ///
    /// - Parameter prefix: An optional string to be prepended to the binary representation.
    ///   The default value is an empty string.
    /// - Returns: The binary string representation of the `Byte`, prefixed as specified.
    func binaryDescription(withPrefix prefix: some StringProtocol = String("")) -> String {
        
        prefix + String(value, radix: 2).paddingTop(with: "0", toLength: 8)
    }
    
    /// [Swim] A string representation of the `Byte` in hexadecimal format.
    var hexadecimalDescription: String {
        
        hexadecimalDescription(withPrefix: "", uppercase: true)
    }
    
    /// [Swim] Returns a hexadecimal string representation of the `Byte`, optionally prefixed and formatted in uppercase or lowercase.
    ///
    /// This function converts the `Byte` value into a hexadecimal string. The result can be
    /// optionally prefixed with a given string, which is useful for indicating hexadecimal notation
    /// (e.g., "0x" for hexadecimal). The `uppercase` parameter determines whether the hexadecimal
    /// characters are uppercased (true) or lowercased (false), catering to different formatting
    /// preferences or standards.
    ///
    /// - Parameters:
    ///   - prefix: An optional string to be prepended to the hexadecimal representation.
    ///     The default is an empty string.
    ///   - uppercase: A Boolean value that determines whether the hexadecimal string should be
    ///     returned in uppercase (true) or lowercase (false). The default is true.
    /// - Returns: The hexadecimal string representation of the `Byte`, with any specified prefix
    ///   and in either uppercase or lowercase as specified.
    func hexadecimalDescription(withPrefix prefix: some StringProtocol = String(""), uppercase: Bool = true) -> String {
        
        prefix + String(value, radix: 16, uppercase: uppercase).paddingTop(with: "0", toLength: 2)
    }
    
    /// [Swim] The number of trailing zero bits in the binary representation of the `Byte`.
    ///
    /// This property calculates and returns the count of zero bits following the last significant bit.
    var trailingZeroBitCount: Int {
        
        value.trailingZeroBitCount
    }
    
    /// [Swim] The number of leading zero bits in the binary representation of the `Byte`.
    ///
    /// This property calculates the count of zero bits preceding the first '1' bit
    /// from the most significant bit towards the least significant bit.
    var leadingZeroBitCount: Int {
        
        value.leadingZeroBitCount
    }
    
    /// [Swim] The number of non-zero bits in the binary representation of the `Byte`.
    ///
    /// This property counts and returns the number of bits that are set to '1' in the `Byte`.
    var nonZeroBitCount: Int {
        
        value.nonzeroBitCount
    }
    
    var mostSignificantBit: Bit {
        uncheckedGetBitInMSB(0)
    }
    
    var leastSignificantBit: Bit {
        uncheckedGetBitInLSB(0)
    }
    
    var complementOfOne: Byte {
        ~self
    }
    
    var complementOfTwo: Byte {
        Byte(~value &+ 1)
    }
    
    subscript (msb n: Int) -> Bit {
        
        get {
            preconditionOverflow(bitCount: n)
            return uncheckedGetBitInMSB(n)
        }
        
        set {
            preconditionOverflow(bitCount: n)
            uncheckedSetInMSB(newValue, to: n)
        }
    }

    static func mask(forBits n: Int) -> UInt8 {
        
        preconditionOverflow(maskBits: n)
        return uncheckedMask(forBits: n)
    }
    
    static func truncatingMask(forBits n: Int) -> UInt8 {
        
        preconditionOverflow(maskBits: n)
        return uncheckedTruncatingMask(forBits: n)
    }
    
    @inline(__always)
    static func uncheckedBitsIndexFromMSBToLSB(_ n: Int) -> Int {
        
        bitWidth - n - 1
    }
    
    /// [Swim] Returns an unchecked mask value for truncating the most significant bit(s) based on the specified number of bits.
    /// - Parameter n: The number of bits to consider for the mask.
    /// - Returns: An unchecked bitmask for truncating the most significant bits.
    static func uncheckedMask(forBits n: Int) -> UInt8 {
        uncheckedTruncatingMask(forBits: bitWidth - n)
    }
    
    static func uncheckedTruncatingMask(forBits n: Int) -> UInt8 {
        ~0 >> n
    }
    
    /// [Swim] Gets the nth bit of the `Byte` to '1'.
    func uncheckedGetBitInLSB(_ n: Int) -> Bit {
        
        value & (1 << n) != 0 ? .one : .zero
    }

    /// [Swim] Gets the nth bit of the `Byte` to '1'.
    func uncheckedGetBitInMSB(_ n: Int) -> Bit {
        
        uncheckedGetBitInLSB(Self.uncheckedBitsIndexFromMSBToLSB(n))
    }
    
    mutating func uncheckedSetInLSB(_ bit: Bit, to n: Int) {
        
        switch bit {
            
        case .one:
            uncheckedSetBitInLSB(n)
            
        case .zero:
            uncheckedResetBitInLSB(n)
        }
    }

    mutating func uncheckedSetInMSB(_ bit: Bit, to n: Int) {
        
        uncheckedSetInLSB(bit, to: Self.uncheckedBitsIndexFromMSBToLSB(n))
    }
    
    /// [Swim] Sets the nth bit of the `Byte` to '1'.
    mutating func uncheckedSetBitInMSB(_ n: Int) {
        
        uncheckedSetBitInLSB(Self.uncheckedBitsIndexFromMSBToLSB(n))
    }
    
    subscript (lsb n: Int) -> Bit {
        
        get {
            preconditionOverflow(bitCount: n)
            return uncheckedGetBitInLSB(n)
        }
        
        set {
            preconditionOverflow(bitCount: n)
            uncheckedSetInLSB(newValue, to: n)
        }
    }
    
    mutating func setBitInMSB(_ n: Int) {
        
        preconditionOverflow(bitCount: n)
        uncheckedSetBitInMSB(n)
    }
    
    mutating func setBitInLSB(_ n: Int) {
        
        preconditionOverflow(bitCount: n)
        uncheckedSetBitInLSB(n)
    }
    
    /// [Swim] Sets the nth bit of the `Byte` to '1'.
    mutating func uncheckedSetBitInLSB(_ n: Int) {
        
        value |= 1 << n
    }

    mutating func resetBitInMSB(_ n: Int) {
        
        preconditionOverflow(bitCount: n)
        uncheckedResetBitInMSB(n)
    }

    /// [Swim] Resets only the bit at the specified position `n` to 0 within the binary representation.
    mutating func uncheckedResetBitInMSB(_ n: Int) {
        
        uncheckedResetBitInLSB(Self.uncheckedBitsIndexFromMSBToLSB(n))
    }

    mutating func resetBitInLSB(_ n: Int) {
        
        preconditionOverflow(bitCount: n)
        uncheckedResetBitInLSB(n)
    }

    /// [Swim] Resets only the bit at the specified position `n` to 0 within the binary representation.
    mutating func uncheckedResetBitInLSB(_ n: Int) {
        
        value &= ~(1 << n)
    }

    mutating func fillWithZero(fromMSB n: Int) {
        
        preconditionOverflow(maskBits: n)
        uncheckedFillWithZero(fromMSB: n)
    }
    
    mutating func uncheckedFillWithZero(fromMSB n: Int) {
        value &= Self.uncheckedTruncatingMask(forBits: n)
    }
    
    mutating func fillWithZero(fromLSB n: Int) {
        
        preconditionOverflow(maskBits: n)
        uncheckedFillWithZero(fromLSB: n)
    }
    
    mutating func uncheckedFillWithZero(fromLSB n: Int) {
        value &= ~Self.uncheckedMask(forBits: n)
    }

    mutating func fillWithOne(fromMSB n: Int) {
        
        preconditionOverflow(maskBits: n)
        uncheckedFillWithOne(fromMSB: n)
    }
    
    mutating func uncheckedFillWithOne(fromMSB n: Int) {
        value |= ~Self.uncheckedTruncatingMask(forBits: n)
    }
    
    mutating func fillWithOne(fromLSB n: Int) {
        
        preconditionOverflow(maskBits: n)
        uncheckedFillWithOne(fromLSB: n)
    }
    
    mutating func uncheckedFillWithOne(fromLSB n: Int) {
        value |= Self.uncheckedMask(forBits: n)
    }

    mutating func copyInLSB(_ value: consuming Byte, from n: Int) {
        
        preconditionOverflow(maskBits: n)
        uncheckedCopyInLSB(value, from: n)
    }
    
    mutating func uncheckedCopyInLSB(_ value: consuming Byte, from n: Int) {
        
        uncheckedFillWithZero(fromLSB: n)
        value.fillWithZero(fromMSB: value.bitWidth - n)
        
        self |= value
    }
    
    mutating func copyInMSB(_ value: consuming Byte, from n: Int) {
        
        preconditionOverflow(maskBits: n)
        uncheckedCopyInMSB(value, from: n)
    }
    
    mutating func uncheckedCopyInMSB(_ value: consuming Byte, from n: Int) {
        
        fillWithZero(fromMSB: n)
        value.fillWithZero(fromLSB: value.bitWidth - n)
        
        self |= value
    }
    
    consuming func filledWithZero(fromMSB n: Int) -> Byte {
        
        fillWithZero(fromMSB: n)
        return self
    }
    
    consuming func uncheckFilledWithZero(fromMSB n: Int) -> Byte {
        
        uncheckedFillWithZero(fromMSB: n)
        return self
    }
    
    consuming func filledWithZero(fromLSB n: Int) -> Byte {
        
        fillWithZero(fromLSB: n)
        return self
    }
    
    consuming func uncheckFilledWithZero(fromLSB n: Int) -> Byte {
        
        uncheckedFillWithZero(fromLSB: n)
        return self
    }
    
    consuming func copiedInLSB(_ value: consuming Byte, from n: Int) -> Byte {
        
        copyInLSB(value, from: n)
        return self
    }
    
    consuming func uncheckedCopiedInLSB(_ value: consuming Byte, from n: Int) -> Byte {
        
        uncheckedCopyInLSB(value, from: n)
        return self
    }
    
    consuming func copiedInMSB(_ value: consuming Byte, from n: Int) -> Byte {
        
        copyInMSB(value, from: n)
        return self
    }
    
    consuming func uncheckCopiedInMSB(_ value: consuming Byte, from n: Int) -> Byte {
        
        uncheckedCopyInMSB(value, from: n)
        return self
    }
}

public extension Byte {
    
    /// The number of bits used to represent a `Byte`.
    ///
    /// For a `Byte`, this property always returns 8, as a byte consists of 8 bits.
    static let bitWidth = 8
    
    /// The range of bits represented by a `Byte`.
    ///
    /// This property defines a range starting from the 0th bit up to, but not including,
    /// the bit at the position specified by `bitWidth`. For a `Byte`, which is 8 bits in size,
    /// `bitRange` will effectively encompass the entire byte (0..<8).
    static let bitRange = 0 ..< bitWidth
    
    static let maskRange = 0 ... bitWidth
    
    static prefix func ~ (byte: Byte) -> Byte {
        Byte(~byte.value)
    }
    
    static func &= (lhs: inout Byte, rhs: Byte) {
        lhs.value &= rhs.value
    }
    
    static func & (lhs: consuming Byte, rhs: Byte) -> Byte {
        lhs &= rhs
        return lhs
    }
    
    static func |= (lhs: inout Byte, rhs: Byte) {
        lhs.value |= rhs.value
    }
    
    static func | (lhs: consuming Byte, rhs: Byte) -> Byte {
        lhs |= rhs
        return lhs
    }
    
    static func ^= (lhs: inout Byte, rhs: Byte) {
        lhs.value ^= rhs.value
    }
    
    static func ^ (lhs: consuming Byte, rhs: Byte) -> Byte {
        lhs ^= rhs
        return lhs
    }
    
    static func <<= (lhs: inout Byte, rhs: Int) {
        lhs.value <<= rhs
    }
    
    static func << (lhs: consuming Byte, rhs: Int) -> Byte {
        lhs <<= rhs
        return lhs
    }
    
    
    static func >>= (lhs: inout Byte, rhs: Int) {
        lhs.value >>= rhs
    }
    
    static func >> (lhs: consuming Byte, rhs: Int) -> Byte {
        lhs >>= rhs
        return lhs
    }
}
