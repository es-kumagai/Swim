//
//  BitArray.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/03/25
//  
//

public struct BitArray {
    
    private(set) var storage: Storage
    private(set) var effectiveBitWidth: Int
}

extension BitArray : MutableCollection, BidirectionalCollection {
    
    public var startIndex: Index {
        Index(0)
    }
    
    public var endIndex: Index {
        Index(effectiveBitWidth)
    }
    
    public func index(after i: Index) -> Index {
        i < endIndex ? i.advanced(by: 1) : endIndex
    }
    
    public func index(before i: Index) -> Index {
        i > startIndex ? i.advanced(by: -1) : startIndex
    }
    
    public subscript(position: Index) -> Bit {
        
        get {
            switch isBitSet(at: position) {
                
            case true:
                return .one
                
            case false:
                return .zero
            }
        }
        
        set {
            switch newValue {
                
            case .one:
                setBit(at: position)
                
            case .zero:
                resetBit(at: position)
            }
        }
    }
}

extension BitArray : Sendable, Codable {
    
}

extension BitArray : Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {

        guard lhs.effectiveBitWidth == rhs.effectiveBitWidth else {
            return false
        }
        
        guard lhs.count == rhs.count else {
            return false
        }
        
        let count = lhs.count
        
        guard count != 0 else {
            return true
        }
        
        return switch count.quotientAndRemainder(dividingBy: Byte.bitWidth) {
        
        case (0, 0):
            true
            
        case let (quotient, 0):
            lhs.storage.prefix(quotient) == rhs.storage.prefix(quotient)
            
        case (0, _):
            lhs.lastByte == rhs.lastByte
            
        case let (quotient, _):
            (lhs.storage.prefix(quotient), lhs.lastByte) == (rhs.storage.prefix(quotient), rhs.lastByte)
        }
    }
}

extension BitArray : ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: Bit...) {
        self.init(elements)
    }
}

private extension BitArray {
    
    func preconditionPositionInRange(_ position: Index, file: StaticString = #file, line: UInt = #line) {
        
        guard indices.contains(position) else {
            preconditionFailure("The position is out of range.", file: file, line: line)
        }
    }

    func preconditionNotEmpty(file: StaticString = #file, line: UInt = #line) {
        
        guard !isEmpty else {
            preconditionFailure("Must not be empty.", file: file, line: line)
        }
    }
}

extension BitArray {
    
    var reservedByteCount: Int {
        storage.count
    }
    
    var freeBitCount: Int {
        storage.bitCount - effectiveBitWidth
    }
    
    var lastByteIndex: Int {

        preconditionNotEmpty()
        return endIndex.byteIndex
    }
    
    var lastByte: Byte {
        
        preconditionNotEmpty()
        return storage[lastByteIndex] & ~Byte.uncheckedTruncatingMask(forBits: endIndex.msbBitIndex)
    }
    
    var lastBitIndexOfLastByte: Int {

        preconditionNotEmpty()
        return endIndex.advanced(by: -1).msbBitIndex
    }
    
    var endBitIndexOfLastByte: Int {
        
        preconditionNotEmpty()
        return endIndex.msbBitIndex
    }
    
    mutating func extendStorageIfNeeded(necessaryBits n: Int) {
        
        let overflowBits = n - freeBitCount

        guard overflowBits > 0 else {
            return
        }
        
        let (bytes, bits) = overflowBits.quotientAndRemainder(dividingBy: Byte.bitWidth)
        let appendingBytes = bytes + (bits > 0 ? 1 : 0)

        guard appendingBytes > 0 else {
            return
        }
        
        storage.reserveCapacity(reservedByteCount + appendingBytes)

        for _ in 0 ..< appendingBytes {
            storage.append(0)
        }
    }
    
    mutating func uncheckedCopyValue(_ integer: some FixedWidthInteger) {
        
        var integer = integer.bigEndian
        let bitWidth = integer.bitWidth

        Swift.withUnsafeBytes(of: &integer) { bytes in
            
            let bytes = UnsafeBufferPointer<Byte>(
                start: UnsafePointer(OpaquePointer(bytes.baseAddress)), count: bytes.count)
            
            uncheckedCopyBits(bytes, significantBitsInMSB: bitWidth)
        }
    }
    
    mutating func uncheckedCopyBits(_ bytes: some BidirectionalCollection<Byte>, significantBitsInMSB significantBits: Int) {
        
        let lastBits = significantBits % Byte.bitWidth

        if lastBits == 0 {
            uncheckedCopyBytes(bytes)
        }
        else {
            uncheckedCopyBytes(bytes.dropLast())
            uncheckedCopyBits(bytes.last!, significantBitsInMSB: lastBits)
        }
    }

    mutating func uncheckedCopyBytes(_ values: some Sequence<Byte>) {
        
        for value in values {
            uncheckedCopyByte(value)
        }
    }
    
    mutating func uncheckedCopyByte(_ value: borrowing Byte) {
        uncheckedCopyBits(value, significantBitsInMSB: Byte.bitWidth)
    }

    mutating func uncheckedCopyBits(_ value: borrowing Byte, significantBitsInMSB significantBits: Int) {

        guard significantBits > 0 else {
            return
        }
        
        let storeByteIndex = lastByteIndex
        let storeBitIndex = endBitIndexOfLastByte
        let storeWidth = Byte.bitWidth - storeBitIndex
        let insignificantBits = Byte.bitWidth - significantBits
        let trailingFreeBits = insignificantBits - storeBitIndex
        let carriedBits = significantBits - storeWidth
        
        storage[storeByteIndex].uncheckedCopy(value >> storeBitIndex, fromLSB: storeWidth)

        if trailingFreeBits > 0 {
            storage[storeByteIndex].fillWithZero(fromLSB: trailingFreeBits)
        }
        
        if carriedBits > 0 {
            
            effectiveBitWidth += storeWidth
            uncheckedCopyBits(value << storeWidth, significantBitsInMSB: carriedBits)
        } else {
            
            effectiveBitWidth += significantBits
        }
    }
    
    mutating func uncheckedReplaceBit(at position: Index, by bit: Bit) {

        switch bit {
            
        case .zero:
            uncheckedResetBit(at: position)
            
        case .one:
            uncheckedSetBit(at: position)
        }
    }
    
    mutating func uncheckedSetBit(at position: Index) {
        storage[position.byteIndex] |= position.bitMask
    }
    
    mutating func uncheckedResetBit(at position: Index) {
        storage[position.byteIndex] &= ~position.bitMask
    }
}

public extension BitArray {
    
    init() {
        self.init(storage: [], effectiveBitWidth: 0)
    }
    
    init(bitWidth: Int) {
        
        self.init(
            storage: Storage(repeating: 0, count: Index(bitWidth).byteWidth),
            effectiveBitWidth: bitWidth
        )
    }
    
    init(_ bits: some Sequence<Bit>) {
        
        self.init()
        
        for bit in bits {
            self.append(bit)
        }
    }
    
    init(_ bits: some Collection<Bit>) {
        
        let endIndex = Index(bits.count)
        var storage = Storage(repeating: 0, count: endIndex.byteWidth)
        
        for (offset, bit) in bits.enumerated() {
            
            let (byteIndex, bitIndex) = offset.quotientAndRemainder(dividingBy: Byte.bitWidth)
            
            storage[byteIndex].uncheckedSetInMSB(bit, to: bitIndex)
        }
        
        self.init(storage: storage, effectiveBitWidth: bits.count)
    }
    
    init(_ integer: some FixedWidthInteger) {
        
        self.init(storage: [], effectiveBitWidth: 0)
        appendValue(integer)
    }
    
    init(_ integers: some Sequence<some FixedWidthInteger>) {
        
        self.init(storage: [], effectiveBitWidth: 0)
        appendValues(integers)
    }
    
    init(_ bits: some BidirectionalCollection<Byte>, eachSignificantBitsInMSB eachSignificantBits: Int) {
        
        self.init(storage: [], effectiveBitWidth: 0)
        appendBits(bits, eachSignificantBitsInMSB: eachSignificantBits)
    }
    
    subscript(bitsFromMSB position: Int) -> Bit {
        
        get {
            self[Index(position)]
        }
        
        set {
            self[Index(position)] = newValue
        }
    }
    
    func isBitSet(at position: Index) -> Bool {
        
        preconditionPositionInRange(position)
        return position.isBitSet(inTargetByte: storage[position.byteIndex])
    }
    
    mutating func replaceBit(at position: Index, by bit: Bit) {
        
        preconditionPositionInRange(position)
        uncheckedReplaceBit(at: position, by: bit)
    }
    
    mutating func setBit(at position: Index) {
        
        preconditionPositionInRange(position)
        uncheckedSetBit(at: position)
    }
    
    mutating func resetBit(at position: Index) {
        
        preconditionPositionInRange(position)
        uncheckedResetBit(at: position)
    }
    
    mutating func append(_ bit: Bit) {
        
        extendStorageIfNeeded(necessaryBits: 1)
        
        uncheckedReplaceBit(at: endIndex, by: bit)
        effectiveBitWidth += 1
    }
    
    mutating func appendByte(_ value: Byte) {
        
        extendStorageIfNeeded(necessaryBits: Byte.bitWidth)
        uncheckedCopyByte(value)
    }
    
    mutating func appendBytes(_ values: some Sequence<Byte>) {
        
        for value in values {
            extendStorageIfNeeded(necessaryBits: Byte.bitWidth)
            uncheckedCopyByte(value)
        }
    }
    
    mutating func appendBytes(_ values: some Collection<Byte>) {
        
        extendStorageIfNeeded(necessaryBits: values.count * Byte.bitWidth)
        
        for value in values {
            uncheckedCopyByte(value)
        }
    }
    
    mutating func appendBits(_ value: Byte, significantBitsInMSB significantBits: Int) {
        
        extendStorageIfNeeded(necessaryBits: significantBits)
        uncheckedCopyBits(value, significantBitsInMSB: significantBits)
    }
    
    mutating func appendBits(_ values: some BidirectionalCollection<Byte>, eachSignificantBitsInMSB eachSignificantBits: Int) {

        let significantBits = values.count * eachSignificantBits
        
        extendStorageIfNeeded(necessaryBits: significantBits)
        
        for value in values {
            uncheckedCopyBits(value, significantBitsInMSB: eachSignificantBits)
        }
    }
    
    mutating func appendValue(_ integer: some FixedWidthInteger) {
        
        extendStorageIfNeeded(necessaryBits: integer.bitWidth)
        uncheckedCopyValue(integer)
    }
    
    mutating func appendValues(_ integers: some Sequence< some FixedWidthInteger>) {
        
        for integer in integers {
            extendStorageIfNeeded(necessaryBits: integer.bitWidth)
            uncheckedCopyValue(integer)
        }
    }
    
    mutating func appendValues<Integer: FixedWidthInteger>(_ integers: some Collection<Integer>) {
        
        extendStorageIfNeeded(necessaryBits: integers.count * Integer.bitWidth)
        
        for integer in integers {
            uncheckedCopyValue(integer)
        }
    }
    
    func withUnsafeBytes<Result>(_ body: (_ bytes: UnsafeRawBufferPointer, _ bitWidth: Int) throws -> Result) rethrows -> Result {
        
        try storage.withUnsafeBytes { bytes in
            try body(bytes, effectiveBitWidth)
        }
    }
}

extension BitArray {
    
    typealias Storage = Array<Byte>
}

extension BitArray.Storage {
    
    var bitCount: Int {
        count * 8
    }
    
    var lastByteIndex: Int! {
        indices.last
    }
}
