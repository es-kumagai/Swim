////
////  UInt5.swift
////
////  
////  Created by Tomohiro Kumagai on 2024/03/24
////  
////

public struct UInt5 {
    
    var store: Byte
}

private extension UInt5 {

    @inline(__always)
    static func assertionValidStore(_ value: UInt5, file: StaticString = #file, line: UInt = #line) {
        assertionValidStore(value.store, file: file, line: line)
    }

    @inline(__always)
    static func assertionValidStore(_ store: Byte, file: StaticString = #file, line: UInt = #line) {
        assert(store & ~Self.maskForStore == 0, "Unused bits must be zero.")
    }

    @inline(__always)
    static func preconditionNotOverflow(_ value: Byte, _ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
        precondition(!Self.isOverflow(value), message(), file: file, line: line)
    }

    @inline(__always)
    func assertionValidStore(_ value: UInt5, file: StaticString = #file, line: UInt = #line) {
        Self.assertionValidStore(value, file: file, line: line)
    }

    @inline(__always)
    func assertionValidStore(_ store: Byte, file: StaticString = #file, line: UInt = #line) {
        Self.assertionValidStore(store, file: file, line: line)
    }

    @inline(__always)
    func preconditionNotOverflow(_ value: Byte, _ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
        Self.preconditionNotOverflow(value, message())
    }

    @inline(__always)
    var storeValueFilledUnusedLSBBitsByOne: Byte {
        
        assertionValidStore(store)
        return store | .mask(forBits: Self.paddingBits)
    }
    
    @inline(__always)
    var rawValueFilledUnusedMSBBitsByOne: Byte {
        
        assertionValidStore(store)
        return rawValue | ~.truncatingMask(forBits: Self.paddingBits)
    }
}

extension UInt5 {

    static let maskForRawValue: Byte = 0b11111
    static let maskForStore: Byte = 0b11111000
    static let paddingBits: Int = 3
    
    static let one = UInt5(store: 0b00001_000)
    
    @inline(__always)
    var paddingBits: Int {
        Self.paddingBits
    }
    
    @inline(__always)
    static func isOverflow(_ value: Byte) -> Bool {
        value & ~maskForRawValue != 0
    }
        
    @inline(__always)
    static func isOverflow(_ value: some BinaryInteger) -> Bool {
        value & ~numericCast(UInt8(maskForRawValue)) != 0
    }
        
    @inline(__always)
    var isOverflow: Bool {
        Self.isOverflow(rawValue)
    }
    
    @inline(__always)
    static func rawValue(fromStoreValue storeValue: Byte) -> Byte {

        assertionValidStore(storeValue)
        return storeValue >> paddingBits
    }
    
    @inline(__always)
    static func storeValue(fromRawValue rawValue: Byte) -> Byte {
        rawValue << paddingBits
    }
}

extension UInt5 : RawRepresentable {
    
    public init(rawValue: Byte) {
        
        Self.preconditionNotOverflow(rawValue, "A value '\(rawValue.decimalDescription)' overflows when stored into 'UInt5'")
        store = Self.storeValue(fromRawValue: rawValue)
    }
    
    public var rawValue: Byte {
        
        get {
            assertionValidStore(store)
            return Self.rawValue(fromStoreValue: store)
        }
        
        set (rawValue) {
            preconditionNotOverflow(rawValue, "A value '\(rawValue.decimalDescription)' overflows when stored into 'UInt5'")
            store = Self.storeValue(fromRawValue: rawValue)
        }
    }
}

extension UInt5 : Sendable, Codable, Hashable {
    
}

extension UInt5 : Comparable {
    
    public static func < (lhs: UInt5, rhs: UInt5) -> Bool {
        UInt8(lhs) < UInt8(rhs)
    }
}

extension UInt5 : CustomStringConvertible {
    
    public var description: String {
        rawValue.decimalDescription
    }
}

extension UInt5 : CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        assert(bitWidth + paddingBits == store.bitWidth, "Unexpected bit width.")
        
        let bitPattern = String(UInt8(store), radix: 2).paddingTop(with: "0", toLength: 8)
        
        return "\(self) (0b\(bitPattern.prefix(bitWidth)) \(bitPattern.suffix(paddingBits)))"
    }
}

extension UInt5 : Strideable {
    
}

extension UInt5 : ExpressibleByIntegerLiteral {
    
    public init(integerLiteral rawValue: UInt8) {
        
        let rawValue = Byte(rawValue)
        
        Self.preconditionNotOverflow(rawValue, "Integer literal '\(rawValue.decimalDescription)' overflows when stored into 'UInt5'")
        store = Self.storeValue(fromRawValue: rawValue)
    }
}

extension UInt5 : AdditiveArithmetic {

    static public let zero = UInt5(store: 0)
    
    public static func + (lhs: UInt5, rhs: UInt5) -> UInt5 {
        
        let result = lhs.addingReportingOverflow(rhs)
        
        precondition(!result.overflow, "Arithmetic operation '\(lhs) + \(rhs)' (on type 'UInt5') results in an overflow")
        
        return result.partialValue
    }
    
    public static func - (lhs: UInt5, rhs: UInt5) -> UInt5 {
        
        let result = lhs.subtractingReportingOverflow(rhs)
        
        precondition(!result.overflow, "Arithmetic operation '\(lhs) - \(rhs)' (on type 'UInt5') results in an overflow")
        
        return result.partialValue
    }
}

extension UInt5 : Numeric {
    
    public init?(exactly source: some BinaryInteger) {
        
        guard !Self.isOverflow(source) else {
            return nil
        }
        
        self.init(rawValue: Byte(truncatingIfNeeded: source))
    }
    
    public static func * (lhs: UInt5, rhs: UInt5) -> UInt5 {
        
        switch lhs.multipliedReportingOverflow(by: rhs) {
            
        case (let result, false):
            return result
            
        case (_, true):
            preconditionFailure("Arithmetic operation '\(lhs) * \(rhs)' (on type 'UInt5') results in an overflow")
        }
    }
    
    public static func *= (lhs: inout UInt5, rhs: UInt5) {
        
        switch lhs.multipliedReportingOverflow(by: rhs) {

        case (let result, false):
            lhs = result
            
        case (_, true):
            preconditionFailure("Arithmetic operation '\(lhs) *= \(rhs)' (on type 'UInt5') results in an overflow")
        }
    }
}

extension UInt5 : BinaryInteger {

    public static let isSigned = false
    
    public init(_ source: some BinaryInteger) {
        
        guard let source = UInt5(exactly: source) else {
            fatalError("Not enough bits to represent the passed value")
        }
        
        self = source
    }
    
    public init<FloatingPoint>(_ source: FloatingPoint) where FloatingPoint : BinaryFloatingPoint {
        
        guard source <= FloatingPoint(UInt5.max) else {
            
            fatalError("\(type(of: source)) value cannot be converted to UInt5 because the result would be greater than UInt5.max")
        }
        
        guard source >= FloatingPoint(UInt5.min) else {
            
            fatalError("\(type(of: source)) value cannot be converted to UInt5 because the result would be less than UInt5.min")
        }
        
        self.init(UInt8(source))
    }
    
    public init?(exactly source: some BinaryFloatingPoint) {
        
        guard let source = UInt8(exactly: source) else {
            return nil
        }
        
        self.init(exactly: source)
    }
    
    public init(truncatingIfNeeded source: some BinaryInteger) {
        
        let value = Byte(UInt8(truncatingIfNeeded: source)) & Self.maskForRawValue
        self.init(rawValue: value)
    }

    public var words: CollectionOfOne<UInt> {
        CollectionOfOne(UInt(rawValue))
    }

    public var trailingZeroBitCount: Int {
        rawValueFilledUnusedMSBBitsByOne.trailingZeroBitCount
    }
    
    public static func % (lhs: consuming UInt5, rhs: UInt5) -> UInt5 {
        
        lhs %= rhs
        return lhs
    }

    public static func %= (lhs: inout UInt5, rhs: UInt5) {
        lhs.rawValue = Byte(UInt8(lhs.rawValue) % UInt8(rhs.rawValue))
    }
        
    public static func &= (lhs: inout UInt5, rhs: UInt5) {
        
        assertionValidStore(lhs)
        assertionValidStore(rhs)
        
        lhs.store &= rhs.store
    }
    
    public static func |= (lhs: inout UInt5, rhs: UInt5) {

        assertionValidStore(lhs)
        assertionValidStore(rhs)
        
        lhs.store |= rhs.store
    }
    
    public static func ^= (lhs: inout UInt5, rhs: UInt5) {

        assertionValidStore(lhs)
        assertionValidStore(rhs)
        
        lhs.store ^= rhs.store
    }
    
    public prefix static func ~ (x: UInt5) -> UInt5 {
        UInt5(store: ~x.store & maskForStore)
    }

    public static func >> <RHS>(lhs: consuming UInt5, rhs: RHS) -> UInt5 where RHS : BinaryInteger {
        
        lhs >>= rhs
        return lhs
    }

    public static func >>= <RHS>(lhs: inout UInt5, rhs: RHS) where RHS : BinaryInteger {
        
        lhs.store >>= rhs
        lhs.store &= maskForStore
    }
    
    public static func << <RHS>(lhs: consuming UInt5, rhs: RHS) -> UInt5 where RHS : BinaryInteger {
        
        lhs <<= rhs
        return lhs
    }

    public static func <<= <RHS>(lhs: inout UInt5, rhs: RHS) where RHS : BinaryInteger {
        
        lhs.store <<= rhs
    }
    
    public func signum() -> UInt5 {
        store == 0 ? .zero : .one
    }
}

extension UInt5 : UnsignedInteger {
    
}

extension UInt5 : FixedWidthInteger {
    
    public static let bitWidth = 5
    public static let max = UInt5(rawValue: 0b00011111)
    public static let min = UInt5.zero

    public init(_truncatingBits bits: UInt) {
        
        self.init(rawValue: Byte(truncatingIfNeeded: bits) & Self.maskForRawValue)
    }
    
    public var nonzeroBitCount: Int {
        storeValueFilledUnusedLSBBitsByOne.nonZeroBitCount
    }
    
    public var leadingZeroBitCount: Int {        
        storeValueFilledUnusedLSBBitsByOne.leadingZeroBitCount
    }
    
    public var byteSwapped: UInt5 {
        self
    }

    public static func &+ (lhs: UInt5, rhs: UInt5) -> UInt5 {
        UInt5(truncatingIfNeeded: UInt8(lhs) &+ UInt8(rhs))
    }
    
    public static func &- (lhs: UInt5, rhs: UInt5) -> UInt5 {
        UInt5(truncatingIfNeeded: UInt8(lhs) &- UInt8(rhs))
    }

    public func dividingFullWidth(_ dividend: (high: UInt5, low: UInt5)) -> (quotient: UInt5, remainder: UInt5) {
        
        guard self != 0 else {
            fatalError("Division by zero")
        }
        
        guard self != 1 else {
            return (dividend.low, 0)
        }
        
        let dividend = UInt16(dividend.high) << bitWidth + UInt16(dividend.low)
        let divisor = UInt16(self)
        
        let (quotient, remainder) = dividend.quotientAndRemainder(dividingBy: divisor)
        
        return (UInt5(truncatingIfNeeded: quotient), UInt5(remainder))
    }
    
    public func addingReportingOverflow(_ rhs: UInt5) -> (partialValue: UInt5, overflow: Bool) {
        
        let value = Byte(UInt8(self) &+ UInt8(rhs))
        
        let partialValue = UInt5(rawValue: value & Self.maskForRawValue)
        let overflow = value & ~Self.maskForRawValue != 0
        
        return (partialValue, overflow)
    }
    
    public func subtractingReportingOverflow(_ rhs: UInt5) -> (partialValue: UInt5, overflow: Bool) {
        
        let value = Byte(UInt8(self) &- UInt8(rhs))

        let partialValue = UInt5(rawValue: value & Self.maskForRawValue)
        let overflow = value & ~Self.maskForRawValue != 0
        
        return (partialValue, overflow)
    }
    
    public func multipliedReportingOverflow(by rhs: UInt5) -> (partialValue: UInt5, overflow: Bool) {

        let value = Byte(UInt8(self) &* UInt8(rhs))

        let partialValue = UInt5(rawValue: value & Self.maskForRawValue)
        let overflow = value & ~Self.maskForRawValue != 0
        
        return (partialValue, overflow)
    }
    
    public func dividedReportingOverflow(by rhs: UInt5) -> (partialValue: UInt5, overflow: Bool) {

        guard rhs != .zero else {
            return (self, true)
        }
        
        let lhs = UInt8(self)
        let rhs = UInt8(rhs)
        
        return (UInt5(lhs / rhs), false)
    }
    
    public func remainderReportingOverflow(dividingBy rhs: UInt5) -> (partialValue: UInt5, overflow: Bool) {
        
        guard rhs != .zero else {
            return (self, true)
        }
        
        let lhs = UInt8(self)
        let rhs = UInt8(rhs)

        return (UInt5(lhs % rhs), false)
    }
}
