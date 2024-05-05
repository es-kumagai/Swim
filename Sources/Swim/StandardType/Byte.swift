//
//  Byte.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/03/26
//  
//

public typealias Bytes = Array<Byte>

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

public extension UInt {
    
    init(_ byte: Byte) {
        self = UInt(byte.value)
    }
}

public extension String {
    
    init(_ byte: Byte) {
        self = byte.hexadecimalDescription
    }
}

extension Byte : Sendable, Hashable, Equatable, Codable {
    
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
    static func preconditionOverflow(bitCount n: Int) {
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
        Self.preconditionOverflow(bitCount: n)
    }
    
    @inline(__always)
    func preconditionOverflow(maskBits n: Int) {
        Self.preconditionOverflow(maskBits: n)
    }
}

public extension Byte {
    
    init() {
        value = 0
    }
    
    init?(_ bits: some Collection<Bit>) {
        
        guard bits.count == Byte.bitWidth else {
            return nil
        }
        
        self.init()
        
        for (position, bit) in bits.enumerated() {
            uncheckedSetInMSB(bit, to: position)
        }
    }
    
    init(truncatingIfNeeded value: some BinaryInteger) {
        self.init(UInt8(truncatingIfNeeded: value))
    }
    
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

    /// [Swim] A string representation of the `Byte` in decimal format.
    var decimalDescription: String {
        value.description
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
    
    static func mask(forBits n: Int) -> Byte {
        
        preconditionOverflow(maskBits: n)
        return uncheckedMask(forBits: n)
    }
    
    static func truncatingMask(forBits n: Int) -> Byte {
        
        preconditionOverflow(maskBits: n)
        return uncheckedTruncatingMask(forBits: n)
    }
    
    static func pickupMaskInMSB(_ n: Int) -> Byte {
        
        preconditionOverflow(bitCount: n)
        return uncheckedPickupMaskInMSB(n)
    }
    
    static func pickupMaskInLSB(_ n: Int) -> Byte {
        
        preconditionOverflow(bitCount: n)
        return uncheckedPickupMaskInLSB(n)
    }

    @inline(__always)
    static func uncheckedBitsIndexFromMSBToLSB(_ n: Int) -> Int {
        bitWidth - n - 1
    }
    
    /// [Swim] Returns an unchecked mask value for truncating the most significant bit(s) based on the specified number of bits.
    /// - Parameter n: The number of bits to consider for the mask.
    /// - Returns: An unchecked bitmask for truncating the most significant bits.
    static func uncheckedMask(forBits n: Int) -> Byte {
        uncheckedTruncatingMask(forBits: bitWidth - n)
    }
    
    static func uncheckedTruncatingMask(forBits n: Int) -> Byte {
        ~0 >> n
    }
    
    static func uncheckedPickupMaskInMSB(_ n: Int) -> Byte {
        1 << uncheckedBitsIndexFromMSBToLSB(n)
    }
    
    static func uncheckedPickupMaskInLSB(_ n: Int) -> Byte {
        1 << n
    }

    /// [Swim] Gets the nth bit of the `Byte` to '1'.
    func uncheckedGetBitInLSB(_ n: Int) -> Bit {
        Bit(self & Self.uncheckedPickupMaskInLSB(n) != 0)
    }

    /// [Swim] Gets the nth bit of the `Byte` to '1'.
    func uncheckedGetBitInMSB(_ n: Int) -> Bit {
        Bit(self & Self.uncheckedPickupMaskInMSB(n) != 0)
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

    mutating func uncheckedSetInLSB(_ bit: Bit, to n: Int) {
        
        switch bit {
            
        case .one:
            uncheckedSetBitInLSB(n)
            
        case .zero:
            uncheckedResetBitInLSB(n)
        }
    }

    mutating func uncheckedSetInMSB(_ bit: Bit, to n: Int) {

        switch bit {
            
        case .one:
            uncheckedSetBitInMSB(n)
            
        case .zero:
            uncheckedResetBitInMSB(n)
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

    mutating func resetBitInMSB(_ n: Int) {
        
        preconditionOverflow(bitCount: n)
        uncheckedResetBitInMSB(n)
    }

    mutating func resetBitInLSB(_ n: Int) {
        
        preconditionOverflow(bitCount: n)
        uncheckedResetBitInLSB(n)
    }

    mutating func fillWithZero(fromMSB n: Int) {
        
        preconditionOverflow(maskBits: n)
        uncheckedFillWithZero(fromMSB: n)
    }

    mutating func fillWithZero(fromLSB n: Int) {
        
        preconditionOverflow(maskBits: n)
        uncheckedFillWithZero(fromLSB: n)
    }

    borrowing func filledWithZero(fromMSB n: Int) -> Byte {
        
        preconditionOverflow(maskBits: n)
        return uncheckFilledWithZero(fromMSB: n)
    }
    
    borrowing func filledWithZero(fromLSB n: Int) -> Byte {

        preconditionOverflow(maskBits: n)
        return uncheckedFilledWithZero(fromLSB: n)
    }
    
    mutating func fillWithOne(fromMSB n: Int) {
        
        preconditionOverflow(maskBits: n)
        uncheckedFillWithOne(fromMSB: n)
    }
    
    mutating func fillWithOne(fromLSB n: Int) {
        
        preconditionOverflow(maskBits: n)
        uncheckedFillWithOne(fromLSB: n)
    }
    
    mutating func copy(_ value: borrowing Byte, fromMSB n: Int) {
        
        preconditionOverflow(maskBits: n)
        uncheckedCopy(value, fromMSB: n)
    }
    
    mutating func copy(_ value: borrowing Byte, fromLSB n: Int) {
        
        preconditionOverflow(maskBits: n)
        uncheckedCopy(value, fromLSB: n)
    }
    
    consuming func copied(_ value: borrowing Byte, fromMSB n: Int) -> Byte {
        
        preconditionOverflow(maskBits: n)
        return uncheckCopied(value, fromMSB: n)
    }
    
    consuming func copied(_ value: borrowing Byte, fromLSB n: Int) -> Byte {

        preconditionOverflow(maskBits: n)
        return uncheckedCopied(value, fromLSB: n)
    }
    
    /// [Swim] Sets the nth bit of the `Byte` to '1'.
    mutating func uncheckedSetBitInMSB(_ n: Int) {
        self |= Self.uncheckedPickupMaskInMSB(n)
    }
    
    /// [Swim] Sets the nth bit of the `Byte` to '1'.
    mutating func uncheckedSetBitInLSB(_ n: Int) {
        self |= Self.uncheckedPickupMaskInLSB(n)
    }

    /// [Swim] Resets only the bit at the specified position `n` to 0 within the binary representation.
    mutating func uncheckedResetBitInMSB(_ n: Int) {
        self &= ~Self.uncheckedPickupMaskInMSB(n)
    }

    /// [Swim] Resets only the bit at the specified position `n` to 0 within the binary representation.
    mutating func uncheckedResetBitInLSB(_ n: Int) {
        self &= ~Self.uncheckedPickupMaskInLSB(n)
    }

    mutating func uncheckedFillWithZero(fromMSB n: Int) {
        self &= Self.uncheckedTruncatingMask(forBits: n)
    }

    mutating func uncheckedFillWithZero(fromLSB n: Int) {
        self &= ~Self.uncheckedMask(forBits: n)
    }

    mutating func uncheckedFillWithOne(fromMSB n: Int) {
        self |= ~Self.uncheckedTruncatingMask(forBits: n)
    }
    
    mutating func uncheckedFillWithOne(fromLSB n: Int) {
        self |= Self.uncheckedMask(forBits: n)
    }

    borrowing func uncheckFilledWithZero(fromMSB n: Int) -> Byte {
        self & Self.uncheckedTruncatingMask(forBits: n)
    }
    
    borrowing func uncheckedFilledWithZero(fromLSB n: Int) -> Byte {
        self & ~Self.uncheckedMask(forBits: n)
    }

    borrowing func uncheckedFilledWithOne(fromMSB n: Int) -> Byte {
        self | ~Self.uncheckedTruncatingMask(forBits: n)
    }
    
    borrowing func uncheckedFilledWithOne(fromLSB n: Int) -> Byte {
        self | Self.uncheckedMask(forBits: n)
    }

    mutating func uncheckedCopy(_ value: borrowing Byte, fromMSB n: Int) {
        
        uncheckedFillWithZero(fromMSB: n)
        self |= value.filledWithZero(fromLSB: value.bitWidth - n)
    }
    
    mutating func uncheckedCopy(_ value: borrowing Byte, fromLSB n: Int) {
        
        uncheckedFillWithZero(fromLSB: n)
        self |= value.filledWithZero(fromMSB: value.bitWidth - n)
    }
    
    borrowing func uncheckCopied(_ value: borrowing Byte, fromMSB n: Int) -> Byte {
        
        var newValue = copy self
        newValue.uncheckedCopy(value, fromMSB: n)
        
        return newValue
    }
    
    borrowing func uncheckedCopied(_ value: borrowing Byte, fromLSB n: Int) -> Byte {
        
        var newValue = copy self
        newValue.uncheckedCopy(value, fromLSB: n)

        return newValue
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
    
    static prefix func ~ (byte: borrowing Byte) -> Byte {
        Byte(~byte.value)
    }
    
    static func &= (lhs: inout Byte, rhs: borrowing Byte) {
        lhs.value &= rhs.value
    }
    
    static func & (lhs: borrowing Byte, rhs: borrowing Byte) -> Byte {
        Byte(lhs.value & rhs.value)
    }
    
    static func |= (lhs: inout Byte, rhs: borrowing Byte) {
        lhs.value |= rhs.value
    }
    
    static func | (lhs: borrowing Byte, rhs: borrowing Byte) -> Byte {
        Byte(lhs.value | rhs.value)
    }
    
    static func ^= (lhs: inout Byte, rhs: borrowing Byte) {
        lhs.value ^= rhs.value
    }
    
    static func ^ (lhs: borrowing Byte, rhs: borrowing Byte) -> Byte {
        Byte(lhs.value ^ rhs.value)
    }
    
    static func <<= (lhs: inout Byte, rhs: some BinaryInteger) {
        lhs.value <<= rhs
    }
    
    static func << (lhs: borrowing Byte, rhs: some BinaryInteger) -> Byte {
        Byte(lhs.value << rhs)
    }
    
    
    static func >>= (lhs: inout Byte, rhs: some BinaryInteger) {
        lhs.value >>= rhs
    }
    
    static func >> (lhs: borrowing Byte, rhs: some BinaryInteger) -> Byte {
        Byte(lhs.value >> rhs)
    }
}

public extension String {

    init(cString bytes: some Sequence<Byte>) {

        self = ContiguousArray(CStringSequence(bytes)).withUnsafeBufferPointer { buffer in
            String(cString: buffer.baseAddress!)
        }
    }
}

public extension UInt5 {
    
    init(bitPatternInMSB bitPattern: Byte) {
        self.init(store: bitPattern)
    }
    
    init(byteAsValue byte: Byte) {
        self.init(rawValue: byte)
    }
    
    static func / (lhs: UInt5, rhs: UInt5) -> UInt5 {
        UInt5(rawValue: Byte(lhs.rawValue.value / rhs.rawValue.value))
    }

    static func /= (lhs: inout UInt5, rhs: UInt5) {
        lhs.rawValue.value /= rhs.rawValue.value
    }
}
