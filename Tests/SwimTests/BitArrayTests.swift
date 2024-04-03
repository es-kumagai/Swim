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
    }
    
    func testByteInitialization() throws {
        
        let byte1 = Byte(0b0000_0000)
        let byte2 = Byte(0b1111_1111)
        let byte3 = Byte(0b0000_1000)

        XCTAssertEqual(UInt8(byte1), 0)
        XCTAssertEqual(UInt8(byte2), 255)
        XCTAssertEqual(UInt8(byte3), 8)
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

        byte.copyInLSB(0b11111111, from: 2)
        XCTAssertEqual(byte, 0b00001011)

        byte.copyInMSB(0b11111111, from: 3)
        XCTAssertEqual(byte, 0b11101011)
        
        byte.copyInLSB(0b01010101, from: 5)
        XCTAssertEqual(byte, 0b11110101)
        
        byte.copyInMSB(0b10101010, from: 5)
        XCTAssertEqual(byte, 0b10101101)
        
        byte.copyInLSB(0b11111111, from: 0)
        XCTAssertEqual(byte, 0b10101101)
        
        byte.copyInMSB(0b11111111, from: 0)
        XCTAssertEqual(byte, 0b10101101)
        
        byte.copyInLSB(0b01111110, from: 1)
        XCTAssertEqual(byte, 0b10101100)
        
        byte.copyInMSB(0b01111110, from: 1)
        XCTAssertEqual(byte, 0b00101100)
        
        byte.copyInLSB(0b01101110, from: 8)
        XCTAssertEqual(byte, 0b01101110)
        
        byte.copyInMSB(0b01111110, from: 8)
        XCTAssertEqual(byte, 0b01111110)
    }
}
