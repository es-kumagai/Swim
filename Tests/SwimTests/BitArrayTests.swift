//
//  BitArrayTests.swift
//  
//  
//  Created by Tomohiro Kumagai on 2024/03/30
//  
//

import XCTest
@testable import Swim

final class BitArrayTests: XCTestCase {

    func testArrayInitialize() throws {
        
        let bits1 = BitArray()
        let bits2 = BitArray(repeating: .zero, count: 5)
        let bits3 = BitArray(repeating: .one, count: 3)

        XCTAssertEqual(bits1, [])
        XCTAssertEqual(bits1.count, 0)
        XCTAssertEqual(bits1.startIndex, 0)
        XCTAssertEqual(bits1.endIndex, 0)
        XCTAssertEqual(bits1.map(String.init(_:)).joined(), "")

        XCTAssertEqual(bits2, [.zero, .zero, .zero, .zero, .zero])
        XCTAssertEqual(bits2.count, 5)
        XCTAssertEqual(bits2.startIndex, 0)
        XCTAssertEqual(bits2.endIndex, 5)
        XCTAssertEqual(bits2.map(String.init(_:)).joined(), "00000")

        XCTAssertEqual(bits3, [.one, .one, .one])
        XCTAssertEqual(bits3.count, 3)
        XCTAssertEqual(bits3.startIndex, 0)
        XCTAssertEqual(bits3.endIndex, 3)
        XCTAssertEqual(bits3.map(String.init(_:)).joined(), "111")
    }
    
    func testArrayCapacity() throws {
        
        var bits = BitArray()
        
        let previousCapacity1 = bits.capacity
        let newCapacity1 = previousCapacity1 + 50
        XCTAssertTrue(bits.capacity < newCapacity1)
        bits.reserveCapacity(newCapacity1)
        XCTAssertNotEqual(previousCapacity1, bits.capacity)
        XCTAssertTrue(bits.capacity > previousCapacity1)
        XCTAssertTrue(bits.capacity >= newCapacity1)

        let previousCapacity2 = bits.capacity
        let newCapacity2 = previousCapacity2 + 30
        XCTAssertTrue(bits.capacity < newCapacity2)
        bits.reserveCapacity(newCapacity2)
        XCTAssertNotEqual(previousCapacity2, bits.capacity)
        XCTAssertTrue(bits.capacity > previousCapacity2)
        XCTAssertTrue(bits.capacity >= newCapacity2)
    }

    func testArrayAppending() throws {
        
        var bits = BitArray()
        
        XCTAssertEqual(bits, [])
        XCTAssertEqual(bits.count, 0)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 0)
        XCTAssertEqual(bits.map(String.init(_:)), [])
        
        let appended1 = bits + CollectionOfOne(.one)
        bits.append(.one)
        XCTAssertEqual(appended1, bits)
        XCTAssertEqual(bits, [
            .one
        ])
        XCTAssertEqual(bits.count, 1)
        XCTAssertEqual(bits.reservedByteCount, 1)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 1)
        XCTAssertEqual(bits.map(String.init(_:)), ["1"])
        
        let appended2 = bits + CollectionOfOne(.zero)
        bits.append(.zero)
        XCTAssertEqual(appended2, bits)
        XCTAssertEqual(bits, [
            .one,
            .zero
        ])
        XCTAssertEqual(bits.count, 2)
        XCTAssertEqual(bits.reservedByteCount, 1)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 2)
        XCTAssertEqual(bits.map(String.init(_:)), ["1", "0"])
        
        let appended3 = bits + CollectionOfOne(.one)
        bits.append(.one)
        XCTAssertEqual(appended3, bits)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one
        ])
        XCTAssertEqual(bits.count, 3)
        XCTAssertEqual(bits.reservedByteCount, 1)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 3)
        XCTAssertEqual(bits.map(String.init(_:)), ["1", "0", "1"])
        
        let appended4 = bits + BitArray(contentsOf: 0b11100011)
        bits.appendByte(0b11100011)
        XCTAssertEqual(appended4, bits)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one
        ])
        XCTAssertEqual(bits.reservedByteCount, 2)
        XCTAssertEqual(bits.count, 11)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 11)
        XCTAssertEqual(bits.map(String.init(_:)), ["1", "0", "1", "1", "1", "1", "0", "0", "0", "1", "1"])
        
        let appended5 = bits + BitArray(contentsOf: 0b10101010, significantBitsInMSB: 3)
        bits.appendBits(0b10101010, significantBitsInMSB: 3)
        XCTAssertEqual(appended5, bits)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
        ])
        XCTAssertEqual(bits.reservedByteCount, 2)
        XCTAssertEqual(bits.count, 14)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 14)
        XCTAssertEqual(bits.map(String.init(_:)), ["1", "0", "1", "1", "1", "1", "0", "0", "0", "1", "1", "1", "0", "1"])
        
        let appended6 = bits + BitArray(contentsOf: 0b10101010, significantBitsInMSB: 2)
        bits.appendBits(0b10101010, significantBitsInMSB: 2)
        XCTAssertEqual(appended6, bits)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
            .one, .zero,
        ])
        XCTAssertEqual(bits.reservedByteCount, 2)
        XCTAssertEqual(bits.count, 16)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 16)
        XCTAssertEqual(bits.map(String.init(_:)), ["1", "0", "1", "1", "1", "1", "0", "0", "0", "1", "1", "1", "0", "1", "1", "0"])
        
        let appended7 = bits + BitArray(contentsOf: 0b11100011)
        bits.appendByte(0b11100011)
        XCTAssertEqual(appended7, bits)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
            .one, .zero,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
        ])
        XCTAssertEqual(bits.reservedByteCount, 3)
        XCTAssertEqual(bits.count, 24)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 24)

        let appended8 = bits + BitArray(contentsOf: 0b10101010, significantBitsInMSB: 2)
        bits.appendBits(0b10101010, significantBitsInMSB: 2)
        XCTAssertEqual(appended8, bits)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
            .one, .zero,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero,
        ])
        XCTAssertEqual(bits.reservedByteCount, 4)
        XCTAssertEqual(bits.count, 26)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 26)
        
        let sequence1: some Sequence<Byte> = [0b11000110, 0b00101110]

        let appended9 = bits + sequence1
        bits.appendBytes(sequence1)
        XCTAssertEqual(appended9, bits)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
            .one, .zero,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
        ])
        XCTAssertEqual(bits.reservedByteCount, 6)
        XCTAssertEqual(bits.count, 42)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 42)

        let collection1: some Collection<Byte> = [0b11000110, 0b00101110]

        let appended10 = bits + collection1
        bits.appendBytes(collection1)
        XCTAssertEqual(appended10, bits)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
            .one, .zero,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
        ])
        XCTAssertEqual(bits.reservedByteCount, 8)
        XCTAssertEqual(bits.count, 58)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 58)
        
        bits.appendBits([0b01001101, 0b11011011], eachSignificantBitsInMSB: 3)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
            .one, .zero,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .zero, .one, .zero, .one, .one, .zero,
        ])
        XCTAssertEqual(bits.reservedByteCount, 8)
        XCTAssertEqual(bits.count, 64)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 64)
        
        bits.appendValue(0b10110011 as UInt8)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
            .one, .zero,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .zero, .one, .zero, .one, .one, .zero,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
        ])
        XCTAssertEqual(bits.reservedByteCount, 9)
        XCTAssertEqual(bits.count, 72)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 72)
        
        bits.appendValue(-77 as Int8) // 0b10110011
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
            .one, .zero,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .zero, .one, .zero, .one, .one, .zero,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
        ])
        XCTAssertEqual(bits.reservedByteCount, 10)
        XCTAssertEqual(bits.count, 80)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 80)
        
        bits.appendValue(0b01011001_11011110 as Int16)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
            .one, .zero,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .zero, .one, .zero, .one, .one, .zero,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
            .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero
        ])
        XCTAssertEqual(bits.reservedByteCount, 12)
        XCTAssertEqual(bits.count, 96)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 96)
        
        bits.append(.zero)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
            .one, .zero,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .zero, .one, .zero, .one, .one, .zero,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
            .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero,
            .zero,
        ])
        XCTAssertEqual(bits.reservedByteCount, 13)
        XCTAssertEqual(bits.count, 97)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 97)
        
        bits.appendValue(0b01011001_11011110 as UInt16)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
            .one, .zero,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .zero, .one, .zero, .one, .one, .zero,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
            .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero,
            .zero,
            .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero,
        ])
        XCTAssertEqual(bits.reservedByteCount, 15)
        XCTAssertEqual(bits.count, 113)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 113)

        bits.appendValue(0b00011111_00010010_01011001_11011110 as Int32)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
            .one, .zero,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .zero, .one, .zero, .one, .one, .zero,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
            .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero,
            .zero,
            .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero,
            .zero, .zero, .zero, .one, .one, .one, .one, .one, .zero, .zero, .zero, .one, .zero, .zero, .one, .zero, .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero,
        ])
        XCTAssertEqual(bits.reservedByteCount, 19)
        XCTAssertEqual(bits.count, 145)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 145)
        
        bits.appendValue(-3074457345618258602 as Int64)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
            .one, .zero,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .zero, .one, .zero, .one, .one, .zero,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
            .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero,
            .zero,
            .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero,
            .zero, .zero, .zero, .one, .one, .one, .one, .one, .zero, .zero, .zero, .one, .zero, .zero, .one, .zero, .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero,
            .one, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .one, .zero,
        ])
        XCTAssertEqual(bits.reservedByteCount, 27)
        XCTAssertEqual(bits.count, 209)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 209)
        
        let sequence2: some Sequence<UInt16> = [0b11000110_00100011, 0b00101110_11101111]
        bits.appendValues(sequence2)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
            .one, .zero,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .zero, .one, .zero, .one, .one, .zero,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
            .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero,
            .zero,
            .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero,
            .zero, .zero, .zero, .one, .one, .one, .one, .one, .zero, .zero, .zero, .one, .zero, .zero, .one, .zero, .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero,
            .one, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .one, .zero, .one, .one, .one, .zero, .one, .one, .one, .zero, .one, .one, .one, .one,
        ])
        XCTAssertEqual(bits.reservedByteCount, 31)
        XCTAssertEqual(bits.count, 241)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 241)

        let collection2: some Collection<UInt16> = [0b11000110_00100011, 0b00101110_11101111]
        bits.appendValues(collection2)
        XCTAssertEqual(bits, [
            .one,
            .zero,
            .one,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero, .one,
            .one, .zero,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .zero, .one, .zero, .one, .one, .zero,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
            .one, .zero, .one, .one, .zero, .zero, .one, .one,
            .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero,
            .zero,
            .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero,
            .zero, .zero, .zero, .one, .one, .one, .one, .one, .zero, .zero, .zero, .one, .zero, .zero, .one, .zero, .zero, .one, .zero, .one, .one, .zero, .zero, .one, .one, .one, .zero, .one, .one, .one, .one, .zero,
            .one, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .zero, .one, .one, .zero,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .one, .zero, .one, .one, .one, .zero, .one, .one, .one, .zero, .one, .one, .one, .one,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .zero, .one, .zero, .zero, .zero, .one, .one, .zero, .zero, .one, .zero, .one, .one, .one, .zero, .one, .one, .one, .zero, .one, .one, .one, .one,
        ])
        XCTAssertEqual(bits.reservedByteCount, 35)
        XCTAssertEqual(bits.count, 273)
        XCTAssertEqual(bits.startIndex, 0)
        XCTAssertEqual(bits.endIndex, 273)
    }
    
    func testArrayPacking() throws {
        
        let bits1: BitArray = [
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero,
            .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
        ]

        let bits2: BitArray = [
            .one, .one, .one, .zero, .zero, .zero, .one, .one,
            .one, .one, .zero, .zero, .zero, .one, .one, .zero,
            .zero, .zero, .one, .zero, .one, .one, .one, .zero,
            .one, .one, .one, .zero, .zero, .zero,
        ]

        let splitted1_1 = bits1.split(by: 8)
        let splitted1_2 = bits1.split(by: 16)
        let splitted1_3 = bits1.split(by: 4)
        let splitted1_4 = bits1.split(by: 5)

        let splitted2_1 = bits2.split(by: 8)
        let splitted2_2 = bits2.split(by: 16)
        let splitted2_3 = bits2.split(by: 4)
        let splitted2_4 = bits2.split(by: 5)

        XCTAssertEqual(splitted1_1?.map(BitArray.init), [
            [.one, .one, .one, .zero, .zero, .zero, .one, .one],
            [.one, .one, .zero, .zero, .zero, .one, .one, .zero],
            [.zero, .zero, .one, .zero, .one, .one, .one, .zero],
            [.one, .one, .one, .zero, .zero, .zero, .one, .one],
        ])
        XCTAssertEqual(splitted1_2?.map(BitArray.init), [
            [.one, .one, .one, .zero, .zero, .zero, .one, .one, .one, .one, .zero, .zero, .zero, .one, .one, .zero],
            [.zero, .zero, .one, .zero, .one, .one, .one, .zero, .one, .one, .one, .zero, .zero, .zero, .one, .one],
        ])
        XCTAssertEqual(splitted1_3?.map(BitArray.init), [
            [.one, .one, .one, .zero],
            [.zero, .zero, .one, .one],
            [.one, .one, .zero, .zero],
            [.zero, .one, .one, .zero],
            [.zero, .zero, .one, .zero],
            [.one, .one, .one, .zero],
            [.one, .one, .one, .zero],
            [.zero, .zero, .one, .one],
        ])
        XCTAssertEqual(splitted1_4?.map(BitArray.init), nil)

        XCTAssertEqual(splitted2_1?.map(BitArray.init), nil)
        XCTAssertEqual(splitted2_2?.map(BitArray.init), nil)
        XCTAssertEqual(splitted2_3?.map(BitArray.init), nil)
        XCTAssertEqual(splitted2_4?.map(BitArray.init), [
            [.one, .one, .one, .zero, .zero],
            [.zero, .one, .one, .one, .one],
            [.zero, .zero, .zero, .one, .one],
            [.zero, .zero, .zero, .one, .zero],
            [.one, .one, .one, .zero, .one],
            [.one, .one, .zero, .zero, .zero],
        ])

        let packed1_1 = bits1.packingInBytes()
        let packed1_2 = bits1.packing(in: UInt8.self)
        let packed1_3 = bits1.packing(in: Int16.self)
        let packed1_4 = bits1.packing(in: UInt5.self)
        let packed1_5 = bits1.uncheckedPackingInBytes(paddingBitInLSB: .zero)
        let packed1_6 = bits1.uncheckedPacking(in: UInt8.self, paddingBitInLSB: .zero)
        let packed1_7 = bits1.uncheckedPacking(in: Int16.self, paddingBitInLSB: .zero)
        let packed1_8 = bits1.uncheckedPacking(in: UInt5.self, paddingBitInLSB: .zero)
        let packed1_11 = bits1.uncheckedPacking(in: UInt5.self, paddingBitInLSB: .one)

        let packed2_1 = bits2.packingInBytes()
        let packed2_2 = bits2.packing(in: UInt8.self)
        let packed2_3 = bits2.packing(in: Int16.self)
        let packed2_4 = bits2.packing(in: UInt5.self)
        let packed2_5 = bits2.uncheckedPackingInBytes(paddingBitInLSB: .zero)
        let packed2_6 = bits2.uncheckedPacking(in: UInt8.self, paddingBitInLSB: .zero)
        let packed2_7 = bits2.uncheckedPacking(in: Int16.self, paddingBitInLSB: .zero)
        let packed2_8 = bits2.uncheckedPacking(in: UInt5.self, paddingBitInLSB: .zero)
        let packed2_11 = bits2.uncheckedPacking(in: UInt8.self, paddingBitInLSB: .one)

        XCTAssertEqual(packed1_1, [0b11100011, 0b11000110, 0b00101110, 0b11100011])
        XCTAssertEqual(packed1_2, [0b11100011, 0b11000110, 0b00101110, 0b11100011])
        XCTAssertEqual(packed1_3, [Int16(bitPattern: 0b11100011_11000110), Int16(bitPattern: 0b00101110_11100011)])
        XCTAssertEqual(packed1_4, nil)
        XCTAssertEqual(packed1_5, packed1_1)
        XCTAssertEqual(packed1_6, packed1_2)
        XCTAssertEqual(packed1_7, packed1_3)
        XCTAssertNotEqual(packed1_8, packed1_4)
        XCTAssertEqual(packed1_8, [0b11100, 0b01111, 0b00011, 0b00010, 0b11101, 0b11000, 0b11_000])
        XCTAssertEqual(packed1_11, [0b11100, 0b01111, 0b00011, 0b00010, 0b11101, 0b11000, 0b11_111])

        XCTAssertEqual(packed2_1, nil)
        XCTAssertEqual(packed2_2, nil)
        XCTAssertEqual(packed2_3, nil)
        XCTAssertEqual(packed2_4, [0b11100, 0b01111, 0b00011, 0b00010, 0b11101, 0b11000])
        XCTAssertNotEqual(packed2_5, packed2_1)
        XCTAssertNotEqual(packed2_6, packed2_2)
        XCTAssertNotEqual(packed2_7, packed2_3)
        XCTAssertEqual(packed2_8, packed2_4)
        XCTAssertEqual(packed2_6, [0b11100011, 0b11000110, 0b00101110, 0b111000_00])
        XCTAssertEqual(packed2_7, [Int16(bitPattern: 0b11100011_11000110), 0b00101110_111000_00])
        XCTAssertEqual(packed2_8, [0b11100, 0b01111, 0b00011, 0b00010, 0b11101, 0b11000])
        XCTAssertEqual(packed2_11, [0b11100011, 0b11000110, 0b00101110, 0b111000_11])
    }
    
    func testBit() throws {
        
        let bit1 = Bit.zero
        let bit2 = Bit.one
        let bit3 = Bit(true)
        let bit4 = Bit(false)
        let bit5 = true as Bit
        let bit6 = false as Bit
        
        XCTAssertFalse(bit1.isSet)
        XCTAssertTrue(bit2.isSet)

        XCTAssertNotEqual(bit1, bit2)
        XCTAssertEqual(bit1, !bit2)
        XCTAssertEqual(!bit1, bit2)
        XCTAssertEqual(bit1, ~bit2)
        XCTAssertEqual(~bit1, bit2)
        XCTAssertEqual(bit1, bit4)
        XCTAssertEqual(bit2, bit3)
        XCTAssertEqual(bit1, bit6)
        XCTAssertEqual(bit2, bit5)

        XCTAssertFalse(Bool(bit1))
        XCTAssertTrue(Bool(bit2))
        XCTAssertTrue(Bool(bit3))
        XCTAssertFalse(Bool(bit4))
        XCTAssertTrue(Bool(bit5))
        XCTAssertFalse(Bool(bit6))
        
        XCTAssertEqual(String(bit1), "0")
        XCTAssertEqual(String(bit2), "1")
        XCTAssertEqual(String(bit3), "1")
        XCTAssertEqual(String(bit4), "0")
        XCTAssertEqual(String(bit5), "1")
        XCTAssertEqual(String(bit6), "0")
        XCTAssertEqual(bit1, Bit("0"))
        XCTAssertEqual(bit2, Bit("1"))
        XCTAssertEqual(bit3, Bit("1"))
        XCTAssertEqual(bit4, Bit("0"))
        XCTAssertEqual(bit5, Bit("1"))
        XCTAssertEqual(bit6, Bit("0"))
    }
    
    func testByteInformation() throws {
        
        let byte1 = Byte(0b0000_0000)
        
        XCTAssertEqual(Byte.bitWidth, 8)
        XCTAssertEqual(Byte.bitRange.lowerBound, 0)
        XCTAssertEqual(Byte.bitRange.upperBound, 8)
        XCTAssertTrue(type(of: Byte.bitRange) == Range<Int>.self)
        XCTAssertEqual(byte1.bitWidth, 8)
        XCTAssertEqual(byte1.bitRange.lowerBound, 0)
        XCTAssertEqual(byte1.bitRange.upperBound, 8)
        XCTAssertTrue(type(of: byte1.bitRange) == Range<Int>.self)
        
        let byte4 = Byte(0b1010_0010)
        let byte5 = Byte(0b0110_0001)
        
        XCTAssertEqual(byte4.mostSignificantBit, .one)
        XCTAssertEqual(byte4.leastSignificantBit, .zero)
        XCTAssertEqual(byte5.mostSignificantBit, .zero)
        XCTAssertEqual(byte5.leastSignificantBit, .one)
    }
    
    func testByteMask() throws {
        
        XCTAssertEqual(Byte.mask(forBits: 0), 0b00000000)
        XCTAssertEqual(Byte.mask(forBits: 1), 0b00000001)
        XCTAssertEqual(Byte.mask(forBits: 2), 0b00000011)
        XCTAssertEqual(Byte.mask(forBits: 3), 0b00000111)
        XCTAssertEqual(Byte.mask(forBits: 4), 0b00001111)
        XCTAssertEqual(Byte.mask(forBits: 5), 0b00011111)
        XCTAssertEqual(Byte.mask(forBits: 6), 0b00111111)
        XCTAssertEqual(Byte.mask(forBits: 7), 0b01111111)
        XCTAssertEqual(Byte.mask(forBits: 8), 0b11111111)
        
        XCTAssertEqual(Byte.truncatingMask(forBits: 0), 0b11111111)
        XCTAssertEqual(Byte.truncatingMask(forBits: 1), 0b01111111)
        XCTAssertEqual(Byte.truncatingMask(forBits: 2), 0b00111111)
        XCTAssertEqual(Byte.truncatingMask(forBits: 3), 0b00011111)
        XCTAssertEqual(Byte.truncatingMask(forBits: 4), 0b00001111)
        XCTAssertEqual(Byte.truncatingMask(forBits: 5), 0b00000111)
        XCTAssertEqual(Byte.truncatingMask(forBits: 6), 0b00000011)
        XCTAssertEqual(Byte.truncatingMask(forBits: 7), 0b00000001)
        XCTAssertEqual(Byte.truncatingMask(forBits: 8), 0b00000000)

        XCTAssertEqual(Byte.pickupMaskInMSB(0), 0b10000000)
        XCTAssertEqual(Byte.pickupMaskInMSB(1), 0b01000000)
        XCTAssertEqual(Byte.pickupMaskInMSB(2), 0b00100000)
        XCTAssertEqual(Byte.pickupMaskInMSB(3), 0b00010000)
        XCTAssertEqual(Byte.pickupMaskInMSB(4), 0b00001000)
        XCTAssertEqual(Byte.pickupMaskInMSB(5), 0b00000100)
        XCTAssertEqual(Byte.pickupMaskInMSB(6), 0b00000010)
        XCTAssertEqual(Byte.pickupMaskInMSB(7), 0b00000001)

        XCTAssertEqual(Byte.pickupMaskInLSB(0), 0b00000001)
        XCTAssertEqual(Byte.pickupMaskInLSB(1), 0b00000010)
        XCTAssertEqual(Byte.pickupMaskInLSB(2), 0b00000100)
        XCTAssertEqual(Byte.pickupMaskInLSB(3), 0b00001000)
        XCTAssertEqual(Byte.pickupMaskInLSB(4), 0b00010000)
        XCTAssertEqual(Byte.pickupMaskInLSB(5), 0b00100000)
        XCTAssertEqual(Byte.pickupMaskInLSB(6), 0b01000000)
        XCTAssertEqual(Byte.pickupMaskInLSB(7), 0b10000000)
    }
    
    func testByteInitialization() throws {
        
        let byte1 = Byte(0b0000_0000)
        let byte2 = Byte(0b1111_1111)
        let byte3 = Byte(0b0000_1000)

        XCTAssertEqual(UInt8(byte1), 0)
        XCTAssertEqual(UInt8(byte2), 255)
        XCTAssertEqual(UInt8(byte3), 8)
        
        let byte4 = Byte(truncatingIfNeeded: 0b01001110011100110)
        
        XCTAssertEqual(byte4, 0b11100110)
        
        let byte5 = Byte()
        
        XCTAssertEqual(byte5, 0)
        XCTAssertEqual(byte5, byte1)
        
        let byte6 = Byte([.zero, .one, .zero, .zero, .one, .one, .zero, .one])
        let byte7 = Byte([.one, .one, .zero, .one, .one, .zero, .zero, .zero])
        let byte8 = Byte([.one, .zero, .one, .one, .zero, .zero, .zero])
        let byte9 = Byte([.one, .zero, .one, .one, .zero, .zero, .zero, .one, .one])

        XCTAssertEqual(byte6, 0b01001101)
        XCTAssertEqual(byte7, 0b11011000)
        XCTAssertNil(byte8)
        XCTAssertNil(byte9)
    }
    
    func testByteBitCount() throws {
        
        let byte1 = Byte(0b0000_0000)
        let byte2 = Byte(0b1111_1111)
        let byte3 = Byte(0b0000_1000)

        XCTAssertEqual(byte1.nonZeroBitCount, 0)
        XCTAssertEqual(byte1.leadingZeroBitCount, 8)
        XCTAssertEqual(byte1.trailingZeroBitCount, 8)
        XCTAssertEqual(byte2.nonZeroBitCount, 8)
        XCTAssertEqual(byte2.leadingZeroBitCount, 0)
        XCTAssertEqual(byte2.trailingZeroBitCount, 0)
        XCTAssertEqual(byte3.nonZeroBitCount, 1)
        XCTAssertEqual(byte3.leadingZeroBitCount, 4)
        XCTAssertEqual(byte3.trailingZeroBitCount, 3)
    }
    
    func testByteNumericConversion() throws {
        
        let byte: Byte = 0b10110011
        
        XCTAssertEqual(UInt8(byte), UInt8(0b10110011))
        XCTAssertEqual(UInt(byte), UInt(0b10110011))
    }
    
    func testByteTextConversion() throws {
        
        let byte1 = Byte(0b0000_0000)
        let byte2 = Byte(0b1111_1111)
        let byte3 = Byte(0b0000_1000)

        XCTAssertEqual(byte1.description, "00")
        XCTAssertEqual(byte2.description, "FF")
        XCTAssertEqual(byte3.description, "08")
        XCTAssertEqual(byte1.debugDescription, "00000000 (00)")
        XCTAssertEqual(byte2.debugDescription, "11111111 (FF)")
        XCTAssertEqual(byte3.debugDescription, "00001000 (08)")

        XCTAssertEqual(String(byte1), "00")
        XCTAssertEqual(String(byte2), "FF")
        XCTAssertEqual(String(byte3), "08")
        XCTAssertEqual(byte1.hexadecimalDescription, "00")
        XCTAssertEqual(byte2.hexadecimalDescription, "FF")
        XCTAssertEqual(byte3.hexadecimalDescription, "08")
        XCTAssertEqual(byte1.hexadecimalDescription(), "00")
        XCTAssertEqual(byte2.hexadecimalDescription(), "FF")
        XCTAssertEqual(byte3.hexadecimalDescription(), "08")
        XCTAssertEqual(byte1.hexadecimalDescription(withPrefix: "0x"), "0x00")
        XCTAssertEqual(byte2.hexadecimalDescription(withPrefix: "0x"), "0xFF")
        XCTAssertEqual(byte3.hexadecimalDescription(withPrefix: "0x"), "0x08")
        XCTAssertEqual(byte1.binaryDescription, "00000000")
        XCTAssertEqual(byte2.binaryDescription, "11111111")
        XCTAssertEqual(byte3.binaryDescription, "00001000")
        XCTAssertEqual(byte1.binaryDescription(withPrefix: "0b"), "0b00000000")
        XCTAssertEqual(byte2.binaryDescription(withPrefix: "0b"), "0b11111111")
        XCTAssertEqual(byte3.binaryDescription(withPrefix: "0b"), "0b00001000")
    }

    func testByteComplement() throws {
        
        let byte1 = Byte(2)
        let byte2 = Byte(0)

        XCTAssertEqual(byte1.complementOfOne, ~byte1)
        XCTAssertEqual(byte1.complementOfOne, 0b11111101)
        XCTAssertEqual(byte1.complementOfTwo, 0b11111110)

        XCTAssertEqual(byte2.complementOfOne, 0b11111111)
        XCTAssertEqual(byte2.complementOfTwo, 0b00000000)
    }
    
    func testByteOperationByOperator() throws {
        
        var byte = Byte(0b0000_1000)
        
        XCTAssertEqual(~byte, 0b11110111)
        XCTAssertEqual(byte & 0b01010101, 0b00000000)
        XCTAssertEqual(byte & byte, byte)
        XCTAssertEqual(byte | 0b01010101, 0b01011101)
        XCTAssertEqual(byte & byte, byte)
        XCTAssertEqual(byte ^ byte, 0b00000000)
        XCTAssertEqual(byte ^ 0b01011010, 0b01010010)
        XCTAssertEqual(byte << 3, 0b01000000)
        XCTAssertEqual(byte >> 2, 0b00000010)
        XCTAssertEqual(byte << 0, byte)
        XCTAssertEqual(byte >> 0, byte)
        
        byte &= 0b01010101
        XCTAssertEqual(byte, 0b00000000)
        
        byte |= 0b01010101
        XCTAssertEqual(byte, 0b01010101)

        byte ^= 0b01010010
        XCTAssertEqual(byte, 0b00000111)

        byte <<= 3
        XCTAssertEqual(byte, 0b00111000)
        
        byte >>= 2
        XCTAssertEqual(byte, 0b00001110)
        
        byte <<= 0
        XCTAssertEqual(byte, 0b00001110)

        byte >>= 0
        XCTAssertEqual(byte, 0b00001110)
    }
    
    func testByteOperationByMethod() throws {
        
        var byte = Byte(0b0000_1000)

        XCTAssertEqual(byte, 8)
        XCTAssertEqual(byte, 0b00001000)

        byte.setBitInMSB(4)
        XCTAssertEqual(byte, 0b00001000)

        byte.setBitInMSB(3)
        XCTAssertEqual(byte, 0b00011000)

        byte.setBitInMSB(0)
        XCTAssertEqual(byte, 0b10011000)
        
        byte.resetBitInMSB(3)
        XCTAssertEqual(byte, 0b10001000)
        
        byte.resetBitInMSB(1)
        XCTAssertEqual(byte, 0b10001000)
        
        byte.setBitInLSB(1)
        XCTAssertEqual(byte, 0b10001010)
        
        byte.setBitInLSB(0)
        XCTAssertEqual(byte, 0b10001011)

        byte.resetBitInLSB(7)
        XCTAssertEqual(byte, 0b00001011)

        byte.resetBitInLSB(7)
        XCTAssertEqual(byte, 0b00001011)
        
        byte.fillWithOne(fromMSB: 3)
        XCTAssertEqual(byte, 0b11101011)
        
        byte.fillWithOne(fromLSB: 3)
        XCTAssertEqual(byte, 0b11101111)
        
        byte.fillWithOne(fromMSB: 8)
        XCTAssertEqual(byte, 0b11111111)
        
        byte.fillWithZero(fromLSB: 2)
        XCTAssertEqual(byte, 0b11111100)
        
        byte.fillWithZero(fromMSB: 5)
        XCTAssertEqual(byte, 0b00000100)
        
        byte.fillWithOne(fromLSB: 0)
        XCTAssertEqual(byte, 0b00000100)
        
        byte.fillWithOne(fromMSB: 0)
        XCTAssertEqual(byte, 0b00000100)
    }
    
    func testByteCopy() throws {
        
        var byte = Byte(0b0000_1000)

        XCTAssertEqual(byte, 0b00001000)

        byte.copy(0b11111111, fromLSB: 2)
        XCTAssertEqual(byte, 0b00001011)

        byte.copy(0b11111111, fromMSB: 3)
        XCTAssertEqual(byte, 0b11101011)
        
        byte.copy(0b01010101, fromLSB: 5)
        XCTAssertEqual(byte, 0b11110101)
        
        byte.copy(0b10101010, fromMSB: 5)
        XCTAssertEqual(byte, 0b10101101)
        
        byte.copy(0b11111111, fromLSB: 0)
        XCTAssertEqual(byte, 0b10101101)
        
        byte.copy(0b11111111, fromMSB: 0)
        XCTAssertEqual(byte, 0b10101101)
        
        byte.copy(0b01111110, fromLSB: 1)
        XCTAssertEqual(byte, 0b10101100)
        
        byte.copy(0b01111110, fromMSB: 1)
        XCTAssertEqual(byte, 0b00101100)
        
        byte.copy(0b01101110, fromLSB: 8)
        XCTAssertEqual(byte, 0b01101110)
        
        byte.copy(0b01111110, fromMSB: 8)
        XCTAssertEqual(byte, 0b01111110)
    }
}
