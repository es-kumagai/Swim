//
//  UInt5Tests.swift
//
//
//  Created by Tomohiro Kumagai on 2024/04/11
//
//

import XCTest
@testable import Swim

struct FixedNumberGenerator : RandomNumberGenerator {
    
    let number: UInt64
    
    init(_ number: UInt64) {
        self.number = number
    }
    
    func next() -> UInt64 {
        number
    }
}

func XCTAssertEqual(_ lhs: (UInt5, Bool), _ rhs: (UInt5, Bool), file: StaticString = #file, line: UInt = #line) {

    XCTAssertEqual(lhs.0, rhs.0, file: file, line: line)
    XCTAssertEqual(lhs.1, rhs.1, file: file, line: line)
}

func XCTAssertEqual(_ lhs: (UInt5, UInt5), _ rhs: (UInt5, UInt5), file: StaticString = #file, line: UInt = #line) {

    XCTAssertEqual(lhs.0, rhs.0, file: file, line: line)
    XCTAssertEqual(lhs.1, rhs.1, file: file, line: line)
}

func XCTAssertArithmetic(uInt5: UInt5, int: Int, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(Int(uInt5), int, file: file, line: line)
}

func XCTAssertShift<Shift : BinaryInteger>(operands immutableOperation: (UInt5, Shift) -> UInt5, _ mutableOperation: (inout UInt5, Shift) -> Void, value: consuming UInt5, shift: Shift, expected: UInt5, file: StaticString = #filePath, line: UInt = #line) {
    
    XCTAssertEqual(immutableOperation(value, shift), expected, file: file, line: line)
    
    mutableOperation(&value, shift)
    XCTAssertEqual(value, expected, file: file, line: line)
}

final class UInt5Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasics() throws {

        XCTAssertEqual(UInt5.one, UInt5(1))
        XCTAssertEqual(UInt5.one.store, 0b00001_000)
    }
    
    func testUtilities() throws {
        
        XCTAssertEqual(UInt5.maskForRawValue, 0b11111)
        XCTAssertEqual(UInt5.maskForStore, 0b11111000)

        XCTAssertFalse(UInt5.isOverflow(0b00000000 as Byte))
        XCTAssertFalse(UInt5.isOverflow(0b00000010 as Byte))
        XCTAssertFalse(UInt5.isOverflow(0b00000100 as Byte))
        XCTAssertFalse(UInt5.isOverflow(0b00001000 as Byte))
        XCTAssertFalse(UInt5.isOverflow(0b00010000 as Byte))
        XCTAssertFalse(UInt5.isOverflow(0b00011111 as Byte))
        XCTAssertTrue(UInt5.isOverflow(0b00100000 as Byte))
        XCTAssertTrue(UInt5.isOverflow(0b01000000 as Byte))
        XCTAssertTrue(UInt5.isOverflow(0b10000000 as Byte))
        XCTAssertTrue(UInt5.isOverflow(0b11111111 as Byte))

        XCTAssertFalse(UInt5.isOverflow(0b00000000 as Int16))
        XCTAssertFalse(UInt5.isOverflow(0b00000010 as Int16))
        XCTAssertFalse(UInt5.isOverflow(0b00000100 as Int16))
        XCTAssertFalse(UInt5.isOverflow(0b00001000 as Int16))
        XCTAssertFalse(UInt5.isOverflow(0b00010000 as Int16))
        XCTAssertFalse(UInt5.isOverflow(0b00011111 as Int16))
        XCTAssertTrue(UInt5.isOverflow(0b00100000 as Int16))
        XCTAssertTrue(UInt5.isOverflow(0b01000000 as Int16))
        XCTAssertTrue(UInt5.isOverflow(0b10000000 as Int16))
        XCTAssertTrue(UInt5.isOverflow(0b11111111 as Int16))
        
        let r1: Byte = 0b00000000
        let r2: Byte = 0b00000111
        let r3: Byte = 0b00001100
        let r4: Byte = 0b00010010
        let r5: Byte = 0b00111001
        let r6: Byte = 0b01101101
        let r7: Byte = 0b11101100
        let r8: Byte = 0b11111111
        
        let s1: Byte = UInt5.storeValue(fromRawValue: r1)
        let s2: Byte = UInt5.storeValue(fromRawValue: r2)
        let s3: Byte = UInt5.storeValue(fromRawValue: r3)
        let s4: Byte = UInt5.storeValue(fromRawValue: r4)
        let s5: Byte = UInt5.storeValue(fromRawValue: r5)
        let s6: Byte = UInt5.storeValue(fromRawValue: r6)
        let s7: Byte = UInt5.storeValue(fromRawValue: r7)
        let s8: Byte = UInt5.storeValue(fromRawValue: r8)

        let rs1: Byte = UInt5.rawValue(fromStoreValue: s1)
        let rs2: Byte = UInt5.rawValue(fromStoreValue: s2)
        let rs3: Byte = UInt5.rawValue(fromStoreValue: s3)
        let rs4: Byte = UInt5.rawValue(fromStoreValue: s4)
        let rs5: Byte = UInt5.rawValue(fromStoreValue: s5)
        let rs6: Byte = UInt5.rawValue(fromStoreValue: s6)
        let rs7: Byte = UInt5.rawValue(fromStoreValue: s7)
        let rs8: Byte = UInt5.rawValue(fromStoreValue: s8)

        XCTAssertEqual(s1, 0b00000000)
        XCTAssertEqual(s2, 0b00111000)
        XCTAssertEqual(s3, 0b01100000)
        XCTAssertEqual(s4, 0b10010000)
        XCTAssertEqual(s5, 0b11001000)
        XCTAssertEqual(s6, 0b01101000)
        XCTAssertEqual(s7, 0b01100000)
        XCTAssertEqual(s8, 0b11111000)

        XCTAssertEqual(rs1, 0b00000000)
        XCTAssertEqual(rs2, 0b00000111)
        XCTAssertEqual(rs3, 0b00001100)
        XCTAssertEqual(rs4, 0b00010010)
        XCTAssertEqual(rs5, 0b00011001)
        XCTAssertEqual(rs6, 0b00001101)
        XCTAssertEqual(rs7, 0b00001100)
        XCTAssertEqual(rs8, 0b00011111)

        XCTAssertEqual(r1, rs1)
        XCTAssertEqual(r2, rs2)
        XCTAssertEqual(r3, rs3)
        XCTAssertEqual(r4, rs4)
        XCTAssertNotEqual(r5, rs5)
        XCTAssertNotEqual(r6, rs6)
        XCTAssertNotEqual(r7, rs7)
        XCTAssertNotEqual(r8, rs8)
        
        XCTAssertEqual((r1 << UInt5.paddingBits) >> UInt5.paddingBits, rs1)
        XCTAssertEqual((r2 << UInt5.paddingBits) >> UInt5.paddingBits, rs2)
        XCTAssertEqual((r3 << UInt5.paddingBits) >> UInt5.paddingBits, rs3)
        XCTAssertEqual((r4 << UInt5.paddingBits) >> UInt5.paddingBits, rs4)
        XCTAssertEqual((r5 << UInt5.paddingBits) >> UInt5.paddingBits, rs5)
        XCTAssertEqual((r6 << UInt5.paddingBits) >> UInt5.paddingBits, rs6)
        XCTAssertEqual((r7 << UInt5.paddingBits) >> UInt5.paddingBits, rs7)
        XCTAssertEqual((r8 << UInt5.paddingBits) >> UInt5.paddingBits, rs8)
    }
    
    func testRawRepresentable() throws {
        
        let r1: Byte = 0b00000000
        let r2: Byte = 0b00000111
        let r3: Byte = 0b00001100
        let r4: Byte = 0b00010010
        let r5: Byte = 0b00011111
        
        let s1 = UInt5(rawValue: r1)
        let s2 = UInt5(rawValue: r2)
        let s3 = UInt5(rawValue: r3)
        let s4 = UInt5(rawValue: r4)
        let s5 = UInt5(rawValue: r5)

        let rs1 = UInt5(store: s1.store)
        let rs2 = UInt5(store: s2.store)
        let rs3 = UInt5(store: s3.store)
        let rs4 = UInt5(store: s4.store)
        let rs5 = UInt5(store: s5.store)

        XCTAssertEqual(s1.rawValue, r1)
        XCTAssertEqual(s2.rawValue, r2)
        XCTAssertEqual(s3.rawValue, r3)
        XCTAssertEqual(s4.rawValue, r4)
        XCTAssertEqual(s5.rawValue, r5)

        XCTAssertEqual(s1.store, 0b00000000)
        XCTAssertEqual(s2.store, 0b00111000)
        XCTAssertEqual(s3.store, 0b01100000)
        XCTAssertEqual(s4.store, 0b10010000)
        XCTAssertEqual(s5.store, 0b11111000)

        XCTAssertEqual(rs1, 0b00000000)
        XCTAssertEqual(rs2, 0b00000111)
        XCTAssertEqual(rs3, 0b00001100)
        XCTAssertEqual(rs4, 0b00010010)
        XCTAssertEqual(rs5, 0b00011111)

        XCTAssertEqual(rs1.store, s1.store)
        XCTAssertEqual(rs2.store, s2.store)
        XCTAssertEqual(rs3.store, s3.store)
        XCTAssertEqual(rs4.store, s4.store)
        XCTAssertEqual(rs5.store, s5.store)

        XCTAssertEqual(r1, rs1.rawValue)
        XCTAssertEqual(r2, rs2.rawValue)
        XCTAssertEqual(r3, rs3.rawValue)
        XCTAssertEqual(r4, rs4.rawValue)
        XCTAssertEqual(r5, rs5.rawValue)
    }
    
    func testComparable() throws {

        let v0: UInt5 = .zero
        let v1: UInt5 = 0
        let v2: UInt5 = 1
        let v3: UInt5 = 16
        let v4: UInt5 = 20
        let v5: UInt5 = 30
        let v6: UInt5 = 31
        
        XCTAssertTrue(v0 == v0)
        XCTAssertTrue(v0 == v1)
        XCTAssertFalse(v0 == v2)
        XCTAssertFalse(v0 == v3)
        XCTAssertFalse(v0 == v4)
        XCTAssertFalse(v0 == v5)
        XCTAssertFalse(v0 == v6)
        
        XCTAssertFalse(v0 != v0)
        XCTAssertFalse(v0 != v1)
        XCTAssertTrue(v0 != v2)
        XCTAssertTrue(v0 != v3)
        XCTAssertTrue(v0 != v4)
        XCTAssertTrue(v0 != v5)
        XCTAssertTrue(v0 != v6)
        
        XCTAssertFalse(v0 < v0)
        XCTAssertFalse(v0 < v1)
        XCTAssertTrue(v0 < v2)
        XCTAssertTrue(v0 < v3)
        XCTAssertTrue(v0 < v4)
        XCTAssertTrue(v0 < v5)
        XCTAssertTrue(v0 < v6)
        
        XCTAssertTrue(v0 <= v0)
        XCTAssertTrue(v0 <= v1)
        XCTAssertTrue(v0 <= v2)
        XCTAssertTrue(v0 <= v3)
        XCTAssertTrue(v0 <= v4)
        XCTAssertTrue(v0 <= v5)
        XCTAssertTrue(v0 <= v6)
        
        XCTAssertFalse(v0 > v0)
        XCTAssertFalse(v0 > v1)
        XCTAssertFalse(v0 > v2)
        XCTAssertFalse(v0 > v3)
        XCTAssertFalse(v0 > v4)
        XCTAssertFalse(v0 > v5)
        XCTAssertFalse(v0 > v6)
        
        XCTAssertTrue(v0 >= v0)
        XCTAssertTrue(v0 >= v1)
        XCTAssertFalse(v0 >= v2)
        XCTAssertFalse(v0 >= v3)
        XCTAssertFalse(v0 >= v4)
        XCTAssertFalse(v0 >= v5)
        XCTAssertFalse(v0 >= v6)
        
        XCTAssertTrue(v1 == v0)
        XCTAssertTrue(v1 == v1)
        XCTAssertFalse(v1 == v2)
        XCTAssertFalse(v1 == v3)
        XCTAssertFalse(v1 == v4)
        XCTAssertFalse(v1 == v5)
        XCTAssertFalse(v1 == v6)
        
        XCTAssertFalse(v1 != v0)
        XCTAssertFalse(v1 != v1)
        XCTAssertTrue(v1 != v2)
        XCTAssertTrue(v1 != v3)
        XCTAssertTrue(v1 != v4)
        XCTAssertTrue(v1 != v5)
        XCTAssertTrue(v1 != v6)
        
        XCTAssertFalse(v1 < v0)
        XCTAssertFalse(v1 < v1)
        XCTAssertTrue(v1 < v2)
        XCTAssertTrue(v1 < v3)
        XCTAssertTrue(v1 < v4)
        XCTAssertTrue(v1 < v5)
        XCTAssertTrue(v1 < v6)
        
        XCTAssertTrue(v1 <= v0)
        XCTAssertTrue(v1 <= v1)
        XCTAssertTrue(v1 <= v2)
        XCTAssertTrue(v1 <= v3)
        XCTAssertTrue(v1 <= v4)
        XCTAssertTrue(v1 <= v5)
        XCTAssertTrue(v1 <= v6)
        
        XCTAssertFalse(v1 > v0)
        XCTAssertFalse(v1 > v1)
        XCTAssertFalse(v1 > v2)
        XCTAssertFalse(v1 > v3)
        XCTAssertFalse(v1 > v4)
        XCTAssertFalse(v1 > v5)
        XCTAssertFalse(v1 > v6)
        
        XCTAssertTrue(v1 >= v0)
        XCTAssertTrue(v1 >= v1)
        XCTAssertFalse(v1 >= v2)
        XCTAssertFalse(v1 >= v3)
        XCTAssertFalse(v1 >= v4)
        XCTAssertFalse(v1 >= v5)
        XCTAssertFalse(v1 >= v6)
        
        XCTAssertFalse(v2 == v0)
        XCTAssertFalse(v2 == v1)
        XCTAssertTrue(v2 == v2)
        XCTAssertFalse(v2 == v3)
        XCTAssertFalse(v2 == v4)
        XCTAssertFalse(v2 == v5)
        XCTAssertFalse(v2 == v6)
        
        XCTAssertTrue(v2 != v0)
        XCTAssertTrue(v2 != v1)
        XCTAssertFalse(v2 != v2)
        XCTAssertTrue(v2 != v3)
        XCTAssertTrue(v2 != v4)
        XCTAssertTrue(v2 != v5)
        XCTAssertTrue(v2 != v6)
        
        XCTAssertFalse(v2 < v0)
        XCTAssertFalse(v2 < v1)
        XCTAssertFalse(v2 < v2)
        XCTAssertTrue(v2 < v3)
        XCTAssertTrue(v2 < v4)
        XCTAssertTrue(v2 < v5)
        XCTAssertTrue(v2 < v6)
        
        XCTAssertFalse(v2 <= v0)
        XCTAssertFalse(v2 <= v1)
        XCTAssertTrue(v2 <= v2)
        XCTAssertTrue(v2 <= v3)
        XCTAssertTrue(v2 <= v4)
        XCTAssertTrue(v2 <= v5)
        XCTAssertTrue(v2 <= v6)
        
        XCTAssertTrue(v2 > v0)
        XCTAssertTrue(v2 > v1)
        XCTAssertFalse(v2 > v2)
        XCTAssertFalse(v2 > v3)
        XCTAssertFalse(v2 > v4)
        XCTAssertFalse(v2 > v5)
        XCTAssertFalse(v2 > v6)
        
        XCTAssertTrue(v2 >= v0)
        XCTAssertTrue(v2 >= v1)
        XCTAssertTrue(v2 >= v2)
        XCTAssertFalse(v2 >= v3)
        XCTAssertFalse(v2 >= v4)
        XCTAssertFalse(v2 >= v5)
        XCTAssertFalse(v2 >= v6)
        
        XCTAssertFalse(v3 == v0)
        XCTAssertFalse(v3 == v1)
        XCTAssertFalse(v3 == v2)
        XCTAssertTrue(v3 == v3)
        XCTAssertFalse(v3 == v4)
        XCTAssertFalse(v3 == v5)
        XCTAssertFalse(v3 == v6)
        
        XCTAssertTrue(v3 != v0)
        XCTAssertTrue(v3 != v1)
        XCTAssertTrue(v3 != v2)
        XCTAssertFalse(v3 != v3)
        XCTAssertTrue(v3 != v4)
        XCTAssertTrue(v3 != v5)
        XCTAssertTrue(v3 != v6)
        
        XCTAssertFalse(v3 < v0)
        XCTAssertFalse(v3 < v1)
        XCTAssertFalse(v3 < v2)
        XCTAssertFalse(v3 < v3)
        XCTAssertTrue(v3 < v4)
        XCTAssertTrue(v3 < v5)
        XCTAssertTrue(v3 < v6)
        
        XCTAssertFalse(v3 <= v0)
        XCTAssertFalse(v3 <= v1)
        XCTAssertFalse(v3 <= v2)
        XCTAssertTrue(v3 <= v3)
        XCTAssertTrue(v3 <= v4)
        XCTAssertTrue(v3 <= v5)
        XCTAssertTrue(v3 <= v6)
        
        XCTAssertTrue(v3 > v0)
        XCTAssertTrue(v3 > v1)
        XCTAssertTrue(v3 > v2)
        XCTAssertFalse(v3 > v3)
        XCTAssertFalse(v3 > v4)
        XCTAssertFalse(v3 > v5)
        XCTAssertFalse(v3 > v6)
        
        XCTAssertTrue(v3 >= v0)
        XCTAssertTrue(v3 >= v1)
        XCTAssertTrue(v3 >= v2)
        XCTAssertTrue(v3 >= v3)
        XCTAssertFalse(v3 >= v4)
        XCTAssertFalse(v3 >= v5)
        XCTAssertFalse(v3 >= v6)
        
        XCTAssertFalse(v4 == v0)
        XCTAssertFalse(v4 == v1)
        XCTAssertFalse(v4 == v2)
        XCTAssertFalse(v4 == v3)
        XCTAssertTrue(v4 == v4)
        XCTAssertFalse(v4 == v5)
        XCTAssertFalse(v4 == v6)
        
        XCTAssertTrue(v4 != v0)
        XCTAssertTrue(v4 != v1)
        XCTAssertTrue(v4 != v2)
        XCTAssertTrue(v4 != v3)
        XCTAssertFalse(v4 != v4)
        XCTAssertTrue(v4 != v5)
        XCTAssertTrue(v4 != v6)
        
        XCTAssertFalse(v4 < v0)
        XCTAssertFalse(v4 < v1)
        XCTAssertFalse(v4 < v2)
        XCTAssertFalse(v4 < v3)
        XCTAssertFalse(v4 < v4)
        XCTAssertTrue(v4 < v5)
        XCTAssertTrue(v4 < v6)
        
        XCTAssertFalse(v4 <= v0)
        XCTAssertFalse(v4 <= v1)
        XCTAssertFalse(v4 <= v2)
        XCTAssertFalse(v4 <= v3)
        XCTAssertTrue(v4 <= v4)
        XCTAssertTrue(v4 <= v5)
        XCTAssertTrue(v4 <= v6)
        
        XCTAssertTrue(v4 > v0)
        XCTAssertTrue(v4 > v1)
        XCTAssertTrue(v4 > v2)
        XCTAssertTrue(v4 > v3)
        XCTAssertFalse(v4 > v4)
        XCTAssertFalse(v4 > v5)
        XCTAssertFalse(v4 > v6)
        
        XCTAssertTrue(v4 >= v0)
        XCTAssertTrue(v4 >= v1)
        XCTAssertTrue(v4 >= v2)
        XCTAssertTrue(v4 >= v3)
        XCTAssertTrue(v4 >= v4)
        XCTAssertFalse(v4 >= v5)
        XCTAssertFalse(v4 >= v6)
        
        XCTAssertFalse(v5 == v0)
        XCTAssertFalse(v5 == v1)
        XCTAssertFalse(v5 == v2)
        XCTAssertFalse(v5 == v3)
        XCTAssertFalse(v5 == v4)
        XCTAssertTrue(v5 == v5)
        XCTAssertFalse(v5 == v6)
        
        XCTAssertTrue(v5 != v0)
        XCTAssertTrue(v5 != v1)
        XCTAssertTrue(v5 != v2)
        XCTAssertTrue(v5 != v3)
        XCTAssertTrue(v5 != v4)
        XCTAssertFalse(v5 != v5)
        XCTAssertTrue(v5 != v6)
        
        XCTAssertTrue(v5 > v0)
        XCTAssertTrue(v5 > v1)
        XCTAssertTrue(v5 > v2)
        XCTAssertTrue(v5 > v3)
        XCTAssertTrue(v5 > v4)
        XCTAssertFalse(v5 < v5)
        XCTAssertTrue(v5 < v6)
        
        XCTAssertTrue(v5 >= v0)
        XCTAssertTrue(v5 >= v1)
        XCTAssertTrue(v5 >= v2)
        XCTAssertTrue(v5 >= v3)
        XCTAssertTrue(v5 >= v4)
        XCTAssertTrue(v5 >= v5)
        XCTAssertTrue(v5 <= v6)
        
        XCTAssertTrue(v5 > v0)
        XCTAssertTrue(v5 > v1)
        XCTAssertTrue(v5 > v2)
        XCTAssertTrue(v5 > v3)
        XCTAssertTrue(v5 > v4)
        XCTAssertFalse(v5 > v5)
        XCTAssertFalse(v5 > v6)

        XCTAssertTrue(v5 >= v0)
        XCTAssertTrue(v5 >= v1)
        XCTAssertTrue(v5 >= v2)
        XCTAssertTrue(v5 >= v3)
        XCTAssertTrue(v5 >= v4)
        XCTAssertTrue(v5 >= v5)
        XCTAssertFalse(v5 >= v6)

        XCTAssertFalse(v6 == v0)
        XCTAssertFalse(v6 == v1)
        XCTAssertFalse(v6 == v2)
        XCTAssertFalse(v6 == v3)
        XCTAssertFalse(v6 == v4)
        XCTAssertFalse(v6 == v5)
        XCTAssertTrue(v6 == v6)

        XCTAssertTrue(v6 != v0)
        XCTAssertTrue(v6 != v1)
        XCTAssertTrue(v6 != v2)
        XCTAssertTrue(v6 != v3)
        XCTAssertTrue(v6 != v4)
        XCTAssertTrue(v6 != v5)
        XCTAssertFalse(v6 != v6)

        XCTAssertFalse(v6 < v0)
        XCTAssertFalse(v6 < v1)
        XCTAssertFalse(v6 < v2)
        XCTAssertFalse(v6 < v3)
        XCTAssertFalse(v6 < v4)
        XCTAssertFalse(v6 < v5)
        XCTAssertFalse(v6 < v6)

        XCTAssertFalse(v6 <= v0)
        XCTAssertFalse(v6 <= v1)
        XCTAssertFalse(v6 <= v2)
        XCTAssertFalse(v6 <= v3)
        XCTAssertFalse(v6 <= v4)
        XCTAssertFalse(v6 <= v5)
        XCTAssertTrue(v6 <= v6)

        XCTAssertTrue(v6 > v0)
        XCTAssertTrue(v6 > v1)
        XCTAssertTrue(v6 > v2)
        XCTAssertTrue(v6 > v3)
        XCTAssertTrue(v6 > v4)
        XCTAssertTrue(v6 > v5)
        XCTAssertFalse(v6 > v6)

        XCTAssertTrue(v6 >= v0)
        XCTAssertTrue(v6 >= v1)
        XCTAssertTrue(v6 >= v2)
        XCTAssertTrue(v6 >= v3)
        XCTAssertTrue(v6 >= v4)
        XCTAssertTrue(v6 >= v5)
        XCTAssertTrue(v6 >= v6)
    }
    
    func testTextExpression() throws {
        
        let v1: UInt5 = 0b00000
        let v2: UInt5 = 0b01100
        let v3: UInt5 = 0b11001
        let v4: UInt5 = 0b11111
        
        XCTAssertEqual(v1.description, "0")
        XCTAssertEqual(v2.description, "12")
        XCTAssertEqual(v3.description, "25")
        XCTAssertEqual(v4.description, "31")
        
        XCTAssertEqual(v1.debugDescription, "0 (0b00000 000)")
        XCTAssertEqual(v2.debugDescription, "12 (0b01100 000)")
        XCTAssertEqual(v3.debugDescription, "25 (0b11001 000)")
        XCTAssertEqual(v4.debugDescription, "31 (0b11111 000)")
    }
    
    func testStrideable() throws {
        
        XCTAssertTrue(UInt5.Stride.self == Int.self)
        
        let v1: UInt5 = 0b00000
        let v2: UInt5 = 0b01100
        let v3: UInt5 = 0b11001
        let v4: UInt5 = 0b11111
        
        XCTAssertEqual(v1.advanced(by: 1), 1)
        XCTAssertEqual(v1.advanced(by: 5), 5)

        XCTAssertEqual(v2.advanced(by: 1), 13)
        XCTAssertEqual(v2.advanced(by: 5), 17)
        XCTAssertEqual(v2.advanced(by: -1), 11)
        XCTAssertEqual(v2.advanced(by: -5), 7)

        XCTAssertEqual(v3.advanced(by: 1), 26)
        XCTAssertEqual(v3.advanced(by: 5), 30)
        XCTAssertEqual(v3.advanced(by: -1), 24)
        XCTAssertEqual(v3.advanced(by: -5), 20)

        XCTAssertEqual(v4.advanced(by: -1), 30)
        XCTAssertEqual(v4.advanced(by: -5), 26)
        
        XCTAssertEqual(v1.advanced(by: 1), v1 + 1)
        XCTAssertEqual(v1.advanced(by: 5), v1 + 5)

        XCTAssertEqual(v2.advanced(by: 1), v2 + 1)
        XCTAssertEqual(v2.advanced(by: 5), v2 + 5)
        XCTAssertEqual(v2.advanced(by: -1), v2 - 1)
        XCTAssertEqual(v2.advanced(by: -5), v2 - 5)

        XCTAssertEqual(v3.advanced(by: 1), v3 + 1)
        XCTAssertEqual(v3.advanced(by: 5), v3 + 5)
        XCTAssertEqual(v3.advanced(by: -1), v3 - 1)
        XCTAssertEqual(v3.advanced(by: -5), v3 - 5)

        XCTAssertEqual(v4.advanced(by: -1), v4 - 1)
        XCTAssertEqual(v4.advanced(by: -5), v4 - 5)

        XCTAssertEqual(v1.distance(to: v1), 0)
        XCTAssertEqual(v1.distance(to: v2), 12)
        XCTAssertEqual(v1.distance(to: v3), 25)
        XCTAssertEqual(v1.distance(to: v4), 31)

        XCTAssertEqual(v2.distance(to: v1), -12)
        XCTAssertEqual(v2.distance(to: v2), 0)
        XCTAssertEqual(v2.distance(to: v3), 13)
        XCTAssertEqual(v2.distance(to: v4), 19)

        XCTAssertEqual(v3.distance(to: v1), -25)
        XCTAssertEqual(v3.distance(to: v2), -13)
        XCTAssertEqual(v3.distance(to: v3), 0)
        XCTAssertEqual(v3.distance(to: v4), 6)

        XCTAssertEqual(v4.distance(to: v1), -31)
        XCTAssertEqual(v4.distance(to: v2), -19)
        XCTAssertEqual(v4.distance(to: v3), -6)
        XCTAssertEqual(v4.distance(to: v4), 0)
        
        XCTAssertEqual(v1.distance(to: v1), Int(v1) - Int(v1))
        XCTAssertEqual(v1.distance(to: v2), Int(v2) - Int(v1))
        XCTAssertEqual(v1.distance(to: v3), Int(v3) - Int(v1))
        XCTAssertEqual(v1.distance(to: v4), Int(v4) - Int(v1))

        XCTAssertEqual(v2.distance(to: v1), Int(v1) - Int(v2))
        XCTAssertEqual(v2.distance(to: v2), Int(v2) - Int(v2))
        XCTAssertEqual(v2.distance(to: v3), Int(v3) - Int(v2))
        XCTAssertEqual(v2.distance(to: v4), Int(v4) - Int(v2))

        XCTAssertEqual(v3.distance(to: v1), Int(v1) - Int(v3))
        XCTAssertEqual(v3.distance(to: v2), Int(v2) - Int(v3))
        XCTAssertEqual(v3.distance(to: v3), Int(v3) - Int(v3))
        XCTAssertEqual(v3.distance(to: v4), Int(v4) - Int(v3))
        
        XCTAssertEqual(v4.distance(to: v1), Int(v1) - Int(v4))
        XCTAssertEqual(v4.distance(to: v2), Int(v2) - Int(v4))
        XCTAssertEqual(v4.distance(to: v3), Int(v3) - Int(v4))
        XCTAssertEqual(v4.distance(to: v4), Int(v4) - Int(v4))
    }
    
    func testLiteralExpression() throws {
        
        let v1: UInt5 = 0b00000
        let v2: UInt5 = 0b01100
        let v3: UInt5 = 0b11001
        let v4: UInt5 = 0b11111
        
        XCTAssertEqual(v1, UInt5(rawValue: 0b00000))
        XCTAssertEqual(v2, UInt5(rawValue: 0b01100))
        XCTAssertEqual(v3, UInt5(rawValue: 0b11001))
        XCTAssertEqual(v4, UInt5(rawValue: 0b11111))
    }
    
    func testAdditiveArithmetic() throws {
        
        XCTAssertEqual(UInt5.zero, UInt5(rawValue: 0))
        
        XCTAssertArithmetic(uInt5: 0 + 0, int: 0 + 0)
        XCTAssertArithmetic(uInt5: 1 + 1, int: 1 + 1)
        XCTAssertArithmetic(uInt5: 10 + 21, int: 10 + 21)

        XCTAssertArithmetic(uInt5: 0 &+ 0, int: 0 &+ 0)
        XCTAssertArithmetic(uInt5: 1 &+ 1, int: 1 &+ 1)
        XCTAssertArithmetic(uInt5: 10 &+ 21, int: 10 &+ 21)
        XCTAssertArithmetic(uInt5: 10 &+ 22, int: 0)
        XCTAssertArithmetic(uInt5: 11 &+ 22, int: 1)

        XCTAssertArithmetic(uInt5: 0 - 0, int: 0 - 0)
        XCTAssertArithmetic(uInt5: 10 - 3, int: 10 - 3)
        XCTAssertArithmetic(uInt5: 20 - 13, int: 20 - 13)

        XCTAssertArithmetic(uInt5: 0 &- 0, int: 0 - 0)
        XCTAssertArithmetic(uInt5: 10 &- 3, int: 10 - 3)
        XCTAssertArithmetic(uInt5: 20 &- 13, int: 20 - 13)
        XCTAssertArithmetic(uInt5: 20 &- 21, int: 31)
        
        var value: UInt5 = 0
        
        value += 0
        XCTAssertArithmetic(uInt5: value, int: 0)
        
        value += 10
        XCTAssertArithmetic(uInt5: value, int: 10)
        
        value += 21
        XCTAssertArithmetic(uInt5: value, int: 31)
        
        value &+= 3
        XCTAssertArithmetic(uInt5: value, int: 2)

        value -= 2
        XCTAssertArithmetic(uInt5: value, int: 0)
        
        value &-= 10
        XCTAssertArithmetic(uInt5: value, int: 22)
        
        value -= 12
        XCTAssertArithmetic(uInt5: value, int: 10)
        
        XCTAssertEqual(+value, 10)
        XCTAssertEqual(+value, value)
    }
    
    func testNumeric() throws {
        
        XCTAssertTrue(UInt5.Magnitude.self == UInt5.self)
        
        let i1: Int = 21
        let i2: Int = -5
        let i3: UInt = 10
        let i4: UInt = 32
        let i5: Int64 = 10
        let i6: Int64 = -8
        let i7: UInt64 = 20
        let i8: UInt64 = 55
        let i9: Int32 = 8
        let i10: Int32 = -120
        let i11: UInt32 = 16
        let i12: UInt32 = 12000
        let i13: Int16 = 1
        let i14: Int16 = -5
        let i15: UInt16 = 0
        let i16: UInt16 = 5000
        let i17: Int8 = 31
        let i18: Int8 = -50
        let i19: UInt8 = 31
        let i20: UInt8 = 255
        
        XCTAssertEqual(UInt5(exactly: i1), 21)
        XCTAssertNil(UInt5(exactly: i2))
        XCTAssertEqual(UInt5(exactly: i3), 10)
        XCTAssertNil(UInt5(exactly: i4))
        XCTAssertEqual(UInt5(exactly: i5), 10)
        XCTAssertNil(UInt5(exactly: i6))
        XCTAssertEqual(UInt5(exactly: i7), 20)
        XCTAssertNil(UInt5(exactly: i8))
        XCTAssertEqual(UInt5(exactly: i9), 8)
        XCTAssertNil(UInt5(exactly: i10))
        XCTAssertEqual(UInt5(exactly: i11), 16)
        XCTAssertNil(UInt5(exactly: i12))
        XCTAssertEqual(UInt5(exactly: i13), 1)
        XCTAssertNil(UInt5(exactly: i14))
        XCTAssertEqual(UInt5(exactly: i15), 0)
        XCTAssertNil(UInt5(exactly: i16))
        XCTAssertEqual(UInt5(exactly: i17), 31)
        XCTAssertNil(UInt5(exactly: i18))
        XCTAssertEqual(UInt5(exactly: i19), 31)
        XCTAssertNil(UInt5(exactly: i20))
        
        var u1: UInt5 = 0
        var u2: UInt5 = 1
        var u3: UInt5 = 8
        var u4: UInt5 = 16
        var u5: UInt5 = 20
        var u6: UInt5 = 21
        var u7: UInt5 = 30
        var u8: UInt5 = 31
        
        XCTAssertEqual(u1.magnitude, u1)
        XCTAssertEqual(u2.magnitude, u2)
        XCTAssertEqual(u3.magnitude, u3)
        XCTAssertEqual(u4.magnitude, u4)
        XCTAssertEqual(u5.magnitude, u5)
        XCTAssertEqual(u6.magnitude, u6)
        XCTAssertEqual(u7.magnitude, u7)
        XCTAssertEqual(u8.magnitude, u8)
        
        XCTAssertArithmetic(uInt5: 0 * 0, int: 0 * 0)
        XCTAssertArithmetic(uInt5: 5 * 0, int: 5 * 0)
        XCTAssertArithmetic(uInt5: 0 * 4, int: 0 * 4)
        XCTAssertArithmetic(uInt5: 4 * 4, int: 4 * 4)
        XCTAssertArithmetic(uInt5: 3 * 8, int: 3 * 8)

        XCTAssertArithmetic(uInt5: 3 &* 5, int: 15)
        XCTAssertArithmetic(uInt5: 4 &* 8, int: 0)
        XCTAssertArithmetic(uInt5: 0 &* 0, int: 0)
        XCTAssertArithmetic(uInt5: 5 &* 0, int: 0)
        XCTAssertArithmetic(uInt5: 3 &* 2, int: 6)
        XCTAssertArithmetic(uInt5: 8 &* 8, int: 0)
        XCTAssertArithmetic(uInt5: 4 &* 9, int: 4)
        
        u1 *= 30
        u2 *= 31
        u3 *= 3
        u4 *= 1
        u5 &*= 2
        u6 &*= 0
        u7 &*= 1
        u8 &*= 3
        
        XCTAssertEqual(u1, 0)
        XCTAssertEqual(u2, 31)
        XCTAssertEqual(u3, 24)
        XCTAssertEqual(u4, 16)
        XCTAssertEqual(u5, 8)
        XCTAssertEqual(u6, 0)
        XCTAssertEqual(u7, 30)
        XCTAssertEqual(u8, 29)
    }
    
    func testBinaryInteger() throws {
        
        XCTAssertFalse(UInt5.isSigned)
        
        let d1: Double = 0
        let d2: Double = 1.5
        let d3: Double = 28.0
        let d4: Double = 31
        let d5: Double = 31.9
        let d6: Double = 32
        let d7: Double = -8
        
        let f1: Double = 0
        let f2: Double = 1.5
        let f3: Double = 28.0
        let f4: Double = 31
        let f5: Double = 31.9
        let f6: Double = 32
        let f7: Double = -8
        
        let i1: some BinaryInteger = 0 as Int16
        let i2: some BinaryInteger = 1 as Int16
        let i3: some BinaryInteger = 28 as Int16
        let i4: some BinaryInteger = 31 as Int16
        let i5: some BinaryInteger = 31 as Int16
        let i6: some BinaryInteger = 32 as Int16
        let i7: some BinaryInteger = -8 as Int16
        let i8: some BinaryInteger = 300 as Int16

        let v1: UInt5 = 0   // 0b00000
        let v2: UInt5 = 1   // 0b00001
        let v3: UInt5 = 28  // 0b11100
        let v4: UInt5 = 31  // 0b11111
        let v5: UInt5 = 31  // 0b11111

        XCTAssertEqual(UInt5(exactly: d1), 0)
        XCTAssertEqual(UInt5(exactly: d2), nil)
        XCTAssertEqual(UInt5(exactly: d3), 28)
        XCTAssertEqual(UInt5(exactly: d4), 31)
        XCTAssertEqual(UInt5(exactly: d5), nil)
        XCTAssertEqual(UInt5(exactly: d6), nil)
        XCTAssertEqual(UInt5(exactly: d7), nil)

        XCTAssertEqual(UInt5(exactly: d1), UInt5(exactly: f1))
        XCTAssertEqual(UInt5(exactly: d2), UInt5(exactly: f2))
        XCTAssertEqual(UInt5(exactly: d3), UInt5(exactly: f3))
        XCTAssertEqual(UInt5(exactly: d4), UInt5(exactly: f4))
        XCTAssertEqual(UInt5(exactly: d5), UInt5(exactly: f5))
        XCTAssertEqual(UInt5(exactly: d6), UInt5(exactly: f6))
        XCTAssertEqual(UInt5(exactly: d7), UInt5(exactly: f7))

        XCTAssertEqual(UInt5(d1), v1)
        XCTAssertEqual(UInt5(d2), v2)
        XCTAssertEqual(UInt5(d3), v3)
        XCTAssertEqual(UInt5(d4), v4)

        XCTAssertEqual(UInt5(i1), v1)
        XCTAssertEqual(UInt5(i2), v2)
        XCTAssertEqual(UInt5(i3), v3)
        XCTAssertEqual(UInt5(i4), v4)

        XCTAssertEqual(UInt5(truncatingIfNeeded: i1), v1)
        XCTAssertEqual(UInt5(truncatingIfNeeded: i2), v2)
        XCTAssertEqual(UInt5(truncatingIfNeeded: i3), v3)
        XCTAssertEqual(UInt5(truncatingIfNeeded: i4), v4)
        XCTAssertEqual(UInt5(truncatingIfNeeded: i5), v5)
        XCTAssertEqual(UInt5(truncatingIfNeeded: i6), 0)
        XCTAssertEqual(UInt5(truncatingIfNeeded: i7), 24)    // 11111111 111 11000
        XCTAssertEqual(UInt5(truncatingIfNeeded: i8), 12)    // 00000001 001 01100

        XCTAssertEqual(UInt5(clamping: i1), v1)
        XCTAssertEqual(UInt5(clamping: i2), v2)
        XCTAssertEqual(UInt5(clamping: i3), v3)
        XCTAssertEqual(UInt5(clamping: i4), v4)
        XCTAssertEqual(UInt5(clamping: i5), v5)
        XCTAssertEqual(UInt5(clamping: i6), 31)
        XCTAssertEqual(UInt5(clamping: i7), 0)
        XCTAssertEqual(UInt5(clamping: i8), 31)

        XCTAssertTrue(UInt5.Words.self == CollectionOfOne<UInt>.self)
        
        XCTAssertEqual(v1.words.map {$0}, [0])
        XCTAssertEqual(v2.words.map {$0}, [1])
        XCTAssertEqual(v3.words.map {$0}, [28])
        XCTAssertEqual(v4.words.map {$0}, [31])
        XCTAssertEqual(v5.words.map {$0}, [31])
        
        XCTAssertEqual(v1.bitWidth, 5)
        XCTAssertEqual(v2.bitWidth, 5)
        XCTAssertEqual(v3.bitWidth, 5)
        XCTAssertEqual(v4.bitWidth, 5)
        XCTAssertEqual(v5.bitWidth, 5)
        
        XCTAssertEqual(v1.trailingZeroBitCount, 5)
        XCTAssertEqual(v2.trailingZeroBitCount, 0)
        XCTAssertEqual(v3.trailingZeroBitCount, 2)
        XCTAssertEqual(v4.trailingZeroBitCount, 0)
        XCTAssertEqual(v5.trailingZeroBitCount, 0)

        func test(_ value: borrowing UInt5, dividingBy rhs: UInt5, quotient: UInt5, remainder: UInt5, file: StaticString = #file, line: UInt = #line) {

            var quotientLHS = copy value
            var remainderLHS = copy value
            
            XCTAssertEqual(quotientLHS / rhs, quotient, "/", file: file, line: line)
            XCTAssertEqual(remainderLHS % rhs, remainder, "%", file: file, line: line)
            
            quotientLHS /= rhs
            remainderLHS %= rhs

            XCTAssertEqual(quotientLHS, quotient, "/=", file: file, line: line)
            XCTAssertEqual(remainderLHS, remainder, "%=", file: file, line: line)

            let result = value.quotientAndRemainder(dividingBy: rhs)
            
            XCTAssertEqual(result.quotient, quotient, "quotientAndRemainder.quotient", file: file, line: line)
            XCTAssertEqual(result.remainder, remainder, "quotientAndRemainder.remainder", file: file, line: line)
        }
        
        var w1 = UInt5(0)
        var w2 = UInt5(8)
        var w3 = UInt5(12)
        var w4 = UInt5(30)
        var w5 = UInt5(31)
        
        test(w1, dividingBy: 1, quotient: w1, remainder: 0)
        test(w1, dividingBy: 3, quotient: 0, remainder: 0)
        test(w1, dividingBy: 8, quotient: 0, remainder: 0)

        test(w2, dividingBy: 1, quotient: w2, remainder: 0)
        test(w2, dividingBy: 2, quotient: 4, remainder: 0)
        test(w2, dividingBy: 10, quotient: 0, remainder: 8)
        test(w2, dividingBy: w2, quotient: 1, remainder: 0)

        test(w3, dividingBy: 1, quotient: w3, remainder: 0)
        test(w3, dividingBy: 8, quotient: 1, remainder: 4)
        test(w3, dividingBy: 31, quotient: 0, remainder: 12)
        test(w3, dividingBy: w3, quotient: 1, remainder: 0)

        test(w4, dividingBy: 1, quotient: w4, remainder: 0)
        test(w4, dividingBy: 5, quotient: 6, remainder: 0)
        test(w4, dividingBy: 20, quotient: 1, remainder: 10)
        test(w4, dividingBy: w4, quotient: 1, remainder: 0)

        test(w5, dividingBy: 1, quotient: w5, remainder: 0)
        test(w5, dividingBy: 8, quotient: 3, remainder: 7)
        test(w5, dividingBy: 20, quotient: 1, remainder: 11)
        test(w5, dividingBy: 30, quotient: 1, remainder: 1)
        test(w5, dividingBy: 31, quotient: 1, remainder: 0)
        
        w1 /= 3
        w2 /= 3
        w3 /= 3
        w4 /= 3
        w5 /= 3
        
        XCTAssertEqual(w1, 0)
        XCTAssertEqual(w2, 2)
        XCTAssertEqual(w3, 4)
        XCTAssertEqual(w4, 10)
        XCTAssertEqual(w5, 10)

        w1 /= 2
        w2 /= 2
        w3 /= 2
        w4 /= 2
        w5 /= 2

        XCTAssertEqual(w1, 0)
        XCTAssertEqual(w2, 1)
        XCTAssertEqual(w3, 2)
        XCTAssertEqual(w4, 5)
        XCTAssertEqual(w5, 5)

        w1 /= 1
        w2 /= 1
        w3 /= 1
        w4 /= 1
        w5 /= 1

        XCTAssertEqual(w1, 0)
        XCTAssertEqual(w2, 1)
        XCTAssertEqual(w3, 2)
        XCTAssertEqual(w4, 5)
        XCTAssertEqual(w5, 5)

        w1 /= 4
        w2 /= 4
        w3 /= 4
        w4 /= 4
        w5 /= 4

        XCTAssertEqual(w1, 0)
        XCTAssertEqual(w2, 0)
        XCTAssertEqual(w3, 0)
        XCTAssertEqual(w4, 1)
        XCTAssertEqual(w5, 1)

        var x1 = UInt5(0)
        var x2 = UInt5(8)
        var x3 = UInt5(12)
        var x4 = UInt5(30)
        var x5 = UInt5(31)

        XCTAssertEqual(x1 % 1, UInt5(0))
        XCTAssertEqual(x1 % 5, UInt5(0))
        XCTAssertEqual(x1 % 7, UInt5(0))
        XCTAssertEqual(x1 % 31, UInt5(0))

        XCTAssertEqual(x2 % 1, UInt5(0))
        XCTAssertEqual(x2 % 5, UInt5(3))
        XCTAssertEqual(x2 % 7, UInt5(1))
        XCTAssertEqual(x2 % 31, UInt5(8))

        XCTAssertEqual(x3 % 1, UInt5(0))
        XCTAssertEqual(x3 % 5, UInt5(2))
        XCTAssertEqual(x3 % 7, UInt5(5))
        XCTAssertEqual(x3 % 31, UInt5(12))

        XCTAssertEqual(x4 % 1, UInt5(0))
        XCTAssertEqual(x4 % 5, UInt5(0))
        XCTAssertEqual(x4 % 7, UInt5(2))
        XCTAssertEqual(x4 % 31, UInt5(30))

        XCTAssertEqual(x5 % 1, UInt5(0))
        XCTAssertEqual(x5 % 5, UInt5(1))
        XCTAssertEqual(x5 % 7, UInt5(3))
        XCTAssertEqual(x5 % 31, UInt5(0))
        
        x1 %= 31
        x2 %= 31
        x3 %= 31
        x4 %= 31
        x5 %= 31

        XCTAssertEqual(x1, 0)
        XCTAssertEqual(x2, 8)
        XCTAssertEqual(x3, 12)
        XCTAssertEqual(x4, 30)
        XCTAssertEqual(x5, 0)

        x1 %= 18
        x2 %= 18
        x3 %= 18
        x4 %= 18
        x5 %= 18

        XCTAssertEqual(x1, 0)
        XCTAssertEqual(x2, 8)
        XCTAssertEqual(x3, 12)
        XCTAssertEqual(x4, 12)
        XCTAssertEqual(x5, 0)

        x1 %= 5
        x2 %= 5
        x3 %= 5
        x4 %= 5
        x5 %= 5

        XCTAssertEqual(x1, 0)
        XCTAssertEqual(x2, 3)
        XCTAssertEqual(x3, 2)
        XCTAssertEqual(x4, 2)
        XCTAssertEqual(x5, 0)

        x1 %= 1
        x2 %= 1
        x3 %= 1
        x4 %= 1
        x5 %= 1

        XCTAssertEqual(x1, 0)
        XCTAssertEqual(x2, 0)
        XCTAssertEqual(x3, 0)
        XCTAssertEqual(x4, 0)
        XCTAssertEqual(x5, 0)

        let notV1 = ~v1
        let notV2 = ~v2
        let notV3 = ~v3
        let notV4 = ~v4

        XCTAssertEqual(notV1, 0b11111)
        XCTAssertEqual(notV1.store, 0b11111_000)
        XCTAssertEqual(notV2, 0b11110)
        XCTAssertEqual(notV2.store, 0b11110_000)
        XCTAssertEqual(notV3, 0b00011)
        XCTAssertEqual(notV3.store, 0b00011_000)
        XCTAssertEqual(notV4, 0b00000)
        XCTAssertEqual(notV4.store, 0b00000_000)
        
        let y1: UInt5 = 0b11111
        let y2: UInt5 = 0b01100
        let y3: UInt5 = 0b10010
        let y4: UInt5 = 0b00000
        
        func test(operands immutableOperation: (UInt5, UInt5) -> UInt5, _ mutableOperation: (inout UInt5, UInt5) -> Void, value: consuming UInt5, mask: UInt5, expected: UInt5, file: StaticString = #filePath, line: UInt = #line) {
            
            XCTAssertEqual(immutableOperation(value, mask), expected, file: file, line: line)
            
            mutableOperation(&value, mask)
            XCTAssertEqual(value, expected, file: file, line: line)
        }
        
        test(operands: &, &=, value: y1, mask: 0b01010, expected: 0b01010)
        test(operands: &, &=, value: y1, mask: 0b11000, expected: 0b11000)
        test(operands: &, &=, value: y1, mask: 0b00011, expected: 0b00011)
        test(operands: &, &=, value: y1, mask: 0b00000, expected: 0b00000)
        test(operands: &, &=, value: y1, mask: 0b11111, expected: y1)
        test(operands: &, &=, value: y1, mask: y1, expected: y1)

        test(operands: &, &=, value: y2, mask: 0b01010, expected: 0b01000)
        test(operands: &, &=, value: y2, mask: 0b11000, expected: 0b01000)
        test(operands: &, &=, value: y2, mask: 0b00010, expected: 0b00000)
        test(operands: &, &=, value: y2, mask: 0b00000, expected: 0b00000)
        test(operands: &, &=, value: y2, mask: 0b11111, expected: y2)
        test(operands: &, &=, value: y2, mask: y2, expected: y2)

        test(operands: &, &=, value: y3, mask: 0b01010, expected: 0b00010)
        test(operands: &, &=, value: y3, mask: 0b11000, expected: 0b10000)
        test(operands: &, &=, value: y3, mask: 0b00011, expected: 0b00010)
        test(operands: &, &=, value: y3, mask: 0b00000, expected: 0b00000)
        test(operands: &, &=, value: y3, mask: 0b11111, expected: y3)
        test(operands: &, &=, value: y3, mask: y3, expected: y3)

        test(operands: &, &=, value: y4, mask: 0b01010, expected: 0b00000)
        test(operands: &, &=, value: y4, mask: 0b11000, expected: 0b00000)
        test(operands: &, &=, value: y4, mask: 0b00010, expected: 0b00000)
        test(operands: &, &=, value: y4, mask: 0b00000, expected: 0b00000)
        test(operands: &, &=, value: y4, mask: 0b11111, expected: y4)
        test(operands: &, &=, value: y4, mask: y4, expected: y4)

        test(operands: |, |=, value: y1, mask: 0b01010, expected: 0b11111)
        test(operands: |, |=, value: y1, mask: 0b11000, expected: 0b11111)
        test(operands: |, |=, value: y1, mask: 0b00011, expected: 0b11111)
        test(operands: |, |=, value: y1, mask: 0b00000, expected: y1)
        test(operands: |, |=, value: y1, mask: 0b11111, expected: 0b11111)
        test(operands: |, |=, value: y1, mask: y1, expected: y1)

        test(operands: |, |=, value: y2, mask: 0b01010, expected: 0b01110)
        test(operands: |, |=, value: y2, mask: 0b11000, expected: 0b11100)
        test(operands: |, |=, value: y2, mask: 0b00010, expected: 0b01110)
        test(operands: |, |=, value: y2, mask: 0b00000, expected: y2)
        test(operands: |, |=, value: y2, mask: 0b11111, expected: 0b11111)
        test(operands: |, |=, value: y2, mask: y2, expected: y2)

        test(operands: |, |=, value: y3, mask: 0b01010, expected: 0b11010)
        test(operands: |, |=, value: y3, mask: 0b11000, expected: 0b11010)
        test(operands: |, |=, value: y3, mask: 0b00011, expected: 0b10011)
        test(operands: |, |=, value: y3, mask: 0b00000, expected: y3)
        test(operands: |, |=, value: y3, mask: 0b11111, expected: 0b11111)
        test(operands: |, |=, value: y3, mask: y3, expected: y3)

        test(operands: |, |=, value: y4, mask: 0b01010, expected: 0b01010)
        test(operands: |, |=, value: y4, mask: 0b11000, expected: 0b11000)
        test(operands: |, |=, value: y4, mask: 0b00010, expected: 0b00010)
        test(operands: |, |=, value: y4, mask: 0b00000, expected: y4)
        test(operands: |, |=, value: y4, mask: 0b11111, expected: 0b11111)
        test(operands: |, |=, value: y4, mask: y4, expected: y4)

        test(operands: ^, ^=, value: y1, mask: 0b01010, expected: 0b10101)
        test(operands: ^, ^=, value: y1, mask: 0b11000, expected: 0b00111)
        test(operands: ^, ^=, value: y1, mask: 0b00011, expected: 0b11100)
        test(operands: ^, ^=, value: y1, mask: 0b00000, expected: y1)
        test(operands: ^, ^=, value: y1, mask: 0b11111, expected: ~y1)
        test(operands: ^, ^=, value: y1, mask: y1, expected: .zero)

        test(operands: ^, ^=, value: y2, mask: 0b01010, expected: 0b00110)
        test(operands: ^, ^=, value: y2, mask: 0b11000, expected: 0b10100)
        test(operands: ^, ^=, value: y2, mask: 0b00010, expected: 0b01110)
        test(operands: ^, ^=, value: y2, mask: 0b00000, expected: y2)
        test(operands: ^, ^=, value: y2, mask: 0b11111, expected: ~y2)
        test(operands: ^, ^=, value: y2, mask: y2, expected: .zero)

        test(operands: ^, ^=, value: y3, mask: 0b01010, expected: 0b11000)
        test(operands: ^, ^=, value: y3, mask: 0b11000, expected: 0b01010)
        test(operands: ^, ^=, value: y3, mask: 0b00011, expected: 0b10001)
        test(operands: ^, ^=, value: y3, mask: 0b00000, expected: y3)
        test(operands: ^, ^=, value: y3, mask: 0b11111, expected: ~y3)
        test(operands: ^, ^=, value: y3, mask: y3, expected: .zero)

        test(operands: ^, ^=, value: y4, mask: 0b01010, expected: 0b01010)
        test(operands: ^, ^=, value: y4, mask: 0b11000, expected: 0b11000)
        test(operands: ^, ^=, value: y4, mask: 0b00010, expected: 0b00010)
        test(operands: ^, ^=, value: y4, mask: 0b00000, expected: y4)
        test(operands: ^, ^=, value: y4, mask: 0b11111, expected: ~y4)
        test(operands: ^, ^=, value: y4, mask: y4, expected: .zero)
        
        XCTAssertEqual(~y1, 0b00000)
        XCTAssertEqual(~y2, 0b10011)
        XCTAssertEqual(~y3, 0b01101)
        XCTAssertEqual(~y4, 0b11111)
        
        XCTAssertShift(operands: >>, >>=, value: y1, shift: 0 as Int, expected: y1)
        XCTAssertShift(operands: >>, >>=, value: y1, shift: 1 as UInt8, expected: 0b01111)
        XCTAssertShift(operands: >>, >>=, value: y1, shift: 3 as Int16, expected: 0b00011)
        XCTAssertShift(operands: >>, >>=, value: y1, shift: 4 as UInt5, expected: 0b00001)
        XCTAssertShift(operands: >>, >>=, value: y1, shift: 5 as UInt32, expected: 0b00000)
        XCTAssertShift(operands: >>, >>=, value: y1, shift: 7 as Int8, expected: 0b00000)
        
        XCTAssertShift(operands: >>, >>=, value: y2, shift: 0 as Int, expected: y2)
        XCTAssertShift(operands: >>, >>=, value: y2, shift: 1 as UInt8, expected: 0b00110)
        XCTAssertShift(operands: >>, >>=, value: y2, shift: 3 as Int16, expected: 0b00001)
        XCTAssertShift(operands: >>, >>=, value: y2, shift: 4 as UInt5, expected: 0b00000)
        XCTAssertShift(operands: >>, >>=, value: y2, shift: 5 as UInt32, expected: 0b00000)
        XCTAssertShift(operands: >>, >>=, value: y2, shift: 7 as Int8, expected: 0b00000)
        
        XCTAssertShift(operands: >>, >>=, value: y3, shift: 0 as Int, expected: y3)
        XCTAssertShift(operands: >>, >>=, value: y3, shift: 1 as UInt8, expected: 0b01001)
        XCTAssertShift(operands: >>, >>=, value: y3, shift: 3 as Int16, expected: 0b00010)
        XCTAssertShift(operands: >>, >>=, value: y3, shift: 4 as UInt5, expected: 0b00001)
        XCTAssertShift(operands: >>, >>=, value: y3, shift: 5 as UInt32, expected: 0b00000)
        XCTAssertShift(operands: >>, >>=, value: y3, shift: 7 as Int8, expected: 0b00000)
        
        XCTAssertShift(operands: >>, >>=, value: y4, shift: 0 as Int, expected: y4)
        XCTAssertShift(operands: >>, >>=, value: y4, shift: 1 as UInt8, expected: 0b00000)
        XCTAssertShift(operands: >>, >>=, value: y4, shift: 3 as Int16, expected: 0b00000)
        XCTAssertShift(operands: >>, >>=, value: y4, shift: 4 as UInt5, expected: 0b00000)
        XCTAssertShift(operands: >>, >>=, value: y4, shift: 5 as UInt32, expected: 0b00000)
        XCTAssertShift(operands: >>, >>=, value: y4, shift: 7 as Int8, expected: 0b00000)
        
        XCTAssertShift(operands: <<, <<=, value: y1, shift: 0 as Int, expected: y1)
        XCTAssertShift(operands: <<, <<=, value: y1, shift: 1 as UInt8, expected: 0b11110)
        XCTAssertShift(operands: <<, <<=, value: y1, shift: 3 as Int16, expected: 0b11000)
        XCTAssertShift(operands: <<, <<=, value: y1, shift: 4 as UInt5, expected: 0b10000)
        XCTAssertShift(operands: <<, <<=, value: y1, shift: 5 as UInt32, expected: 0b00000)
        XCTAssertShift(operands: <<, <<=, value: y1, shift: 7 as Int8, expected: 0b00000)
        
        XCTAssertShift(operands: <<, <<=, value: y2, shift: 0 as Int, expected: y2)
        XCTAssertShift(operands: <<, <<=, value: y2, shift: 1 as UInt8, expected: 0b11000)
        XCTAssertShift(operands: <<, <<=, value: y2, shift: 3 as Int16, expected: 0b00000)
        XCTAssertShift(operands: <<, <<=, value: y2, shift: 4 as UInt5, expected: 0b00000)
        XCTAssertShift(operands: <<, <<=, value: y2, shift: 5 as UInt32, expected: 0b00000)
        XCTAssertShift(operands: <<, <<=, value: y2, shift: 7 as Int8, expected: 0b00000)
        
        XCTAssertShift(operands: <<, <<=, value: y3, shift: 0 as Int, expected: y3)
        XCTAssertShift(operands: <<, <<=, value: y3, shift: 1 as UInt8, expected: 0b00100)
        XCTAssertShift(operands: <<, <<=, value: y3, shift: 3 as Int16, expected: 0b10000)
        XCTAssertShift(operands: <<, <<=, value: y3, shift: 4 as UInt5, expected: 0b00000)
        XCTAssertShift(operands: <<, <<=, value: y3, shift: 5 as UInt32, expected: 0b00000)
        XCTAssertShift(operands: <<, <<=, value: y3, shift: 7 as Int8, expected: 0b00000)
        
        XCTAssertShift(operands: <<, <<=, value: y4, shift: 0 as Int, expected: y4)
        XCTAssertShift(operands: <<, <<=, value: y4, shift: 1 as UInt8, expected: 0b00000)
        XCTAssertShift(operands: <<, <<=, value: y4, shift: 3 as Int16, expected: 0b00000)
        XCTAssertShift(operands: <<, <<=, value: y4, shift: 4 as UInt5, expected: 0b00000)
        XCTAssertShift(operands: <<, <<=, value: y4, shift: 5 as UInt32, expected: 0b00000)
        XCTAssertShift(operands: <<, <<=, value: y4, shift: 7 as Int8, expected: 0b00000)

        XCTAssertTrue(v1.isMultiple(of: 0))
        XCTAssertTrue(v1.isMultiple(of: 1))
        XCTAssertTrue(v1.isMultiple(of: 2))
        XCTAssertTrue(v1.isMultiple(of: 3))
        XCTAssertTrue(v1.isMultiple(of: 5))
        XCTAssertTrue(v1.isMultiple(of: v1))

        XCTAssertFalse(v2.isMultiple(of: 0))
        XCTAssertTrue(v2.isMultiple(of: 1))
        XCTAssertFalse(v2.isMultiple(of: 2))
        XCTAssertFalse(v2.isMultiple(of: 3))
        XCTAssertFalse(v2.isMultiple(of: 5))
        XCTAssertTrue(v2.isMultiple(of: v2))

        XCTAssertFalse(v3.isMultiple(of: 0))
        XCTAssertTrue(v3.isMultiple(of: 1))
        XCTAssertTrue(v3.isMultiple(of: 2))
        XCTAssertFalse(v3.isMultiple(of: 3))
        XCTAssertFalse(v3.isMultiple(of: 5))
        XCTAssertTrue(v3.isMultiple(of: v3))

        XCTAssertFalse(v4.isMultiple(of: 0))
        XCTAssertTrue(v4.isMultiple(of: 1))
        XCTAssertFalse(v4.isMultiple(of: 2))
        XCTAssertFalse(v4.isMultiple(of: 3))
        XCTAssertFalse(v4.isMultiple(of: 5))
        XCTAssertTrue(v4.isMultiple(of: v4))

        XCTAssertFalse(v5.isMultiple(of: 0))
        XCTAssertTrue(v5.isMultiple(of: 1))
        XCTAssertFalse(v5.isMultiple(of: 2))
        XCTAssertFalse(v5.isMultiple(of: 3))
        XCTAssertFalse(v5.isMultiple(of: 5))
        XCTAssertTrue(v5.isMultiple(of: v5))

        XCTAssertEqual(v1.isMultiple(of: 0), Int(v1).isMultiple(of: 0))
        XCTAssertEqual(v1.isMultiple(of: 1), Int(v1).isMultiple(of: 1))
        XCTAssertEqual(v1.isMultiple(of: 2), Int(v1).isMultiple(of: 2))
        XCTAssertEqual(v1.isMultiple(of: 3), Int(v1).isMultiple(of: 3))
        XCTAssertEqual(v1.isMultiple(of: 5), Int(v1).isMultiple(of: 5))
        XCTAssertEqual(v1.isMultiple(of: v1), Int(v1).isMultiple(of: Int(v1)))

        XCTAssertEqual(v2.isMultiple(of: 0), Int(v2).isMultiple(of: 0))
        XCTAssertEqual(v2.isMultiple(of: 1), Int(v2).isMultiple(of: 1))
        XCTAssertEqual(v2.isMultiple(of: 2), Int(v2).isMultiple(of: 2))
        XCTAssertEqual(v2.isMultiple(of: 3), Int(v2).isMultiple(of: 3))
        XCTAssertEqual(v2.isMultiple(of: 5), Int(v2).isMultiple(of: 5))
        XCTAssertEqual(v2.isMultiple(of: v2), Int(v2).isMultiple(of: Int(v2)))

        XCTAssertEqual(v3.isMultiple(of: 0), Int(v3).isMultiple(of: 0))
        XCTAssertEqual(v3.isMultiple(of: 1), Int(v3).isMultiple(of: 1))
        XCTAssertEqual(v3.isMultiple(of: 2), Int(v3).isMultiple(of: 2))
        XCTAssertEqual(v3.isMultiple(of: 3), Int(v3).isMultiple(of: 3))
        XCTAssertEqual(v3.isMultiple(of: 5), Int(v3).isMultiple(of: 5))
        XCTAssertEqual(v3.isMultiple(of: v3), Int(v3).isMultiple(of: Int(v3)))

        XCTAssertEqual(v4.isMultiple(of: 0), Int(v4).isMultiple(of: 0))
        XCTAssertEqual(v4.isMultiple(of: 1), Int(v4).isMultiple(of: 1))
        XCTAssertEqual(v4.isMultiple(of: 2), Int(v4).isMultiple(of: 2))
        XCTAssertEqual(v4.isMultiple(of: 3), Int(v4).isMultiple(of: 3))
        XCTAssertEqual(v4.isMultiple(of: 5), Int(v4).isMultiple(of: 5))
        XCTAssertEqual(v4.isMultiple(of: v4), Int(v4).isMultiple(of: Int(v4)))

        XCTAssertEqual(v5.isMultiple(of: 0), Int(v5).isMultiple(of: 0))
        XCTAssertEqual(v5.isMultiple(of: 1), Int(v5).isMultiple(of: 1))
        XCTAssertEqual(v5.isMultiple(of: 2), Int(v5).isMultiple(of: 2))
        XCTAssertEqual(v5.isMultiple(of: 3), Int(v5).isMultiple(of: 3))
        XCTAssertEqual(v5.isMultiple(of: 5), Int(v5).isMultiple(of: 5))
        XCTAssertEqual(v5.isMultiple(of: v5), Int(v5).isMultiple(of: Int(v5)))

        XCTAssertEqual(y1.signum(), 1)
        XCTAssertEqual(y2.signum(), 1)
        XCTAssertEqual(y3.signum(), 1)
        XCTAssertEqual(y4.signum(), 0)
    }
    
    func testFixedWidthInteger() throws {
        
        XCTAssertEqual(UInt5.bitWidth, 5)
        XCTAssertEqual(UInt5.max, 0b11111)
        XCTAssertEqual(UInt5.max.store, 0b11111_000)
        XCTAssertEqual(UInt5.min, 0b00000)
        XCTAssertEqual(UInt5.min.store, 0b00000_000)

        let v1: UInt5 = 0
        let v2: UInt5 = 1
        let v3: UInt5 = 10
        let v4: UInt5 = 11
        let v5: UInt5 = 20

        XCTAssertEqual(v1.addingReportingOverflow(0), (0, false))
        XCTAssertEqual(v2.addingReportingOverflow(1), (2, false))
        XCTAssertEqual(v3.addingReportingOverflow(21), (31, false))
        XCTAssertEqual(v3.addingReportingOverflow(22), (0, true))
        XCTAssertEqual(v4.addingReportingOverflow(22), (1, true))
        XCTAssertEqual(v5.addingReportingOverflow(20), (8, true))

        XCTAssertEqual(v1.subtractingReportingOverflow(0), (0, false))
        XCTAssertEqual(v2.subtractingReportingOverflow(3), (30, true))
        XCTAssertEqual(v3.subtractingReportingOverflow(13), (29, true))
        XCTAssertEqual(v3.subtractingReportingOverflow(21), (21, true))
        XCTAssertEqual(v4.subtractingReportingOverflow(20), (23, true))
        XCTAssertEqual(v5.subtractingReportingOverflow(4), (16, false))
        
        XCTAssertEqual(v1.multipliedReportingOverflow(by: 0), (0, false))
        XCTAssertEqual(v2.multipliedReportingOverflow(by: 3), (3, false))
        XCTAssertEqual(v3.multipliedReportingOverflow(by: 13), (UInt5(truncatingIfNeeded: (Int(v3) * 13) % 32), true))
        XCTAssertEqual(v3.multipliedReportingOverflow(by: 21), (UInt5(truncatingIfNeeded: (Int(v3) * 21) % 32), true))
        XCTAssertEqual(v4.multipliedReportingOverflow(by: 20), (UInt5(truncatingIfNeeded: (Int(v4) * 20) % 32), true))
        XCTAssertEqual(v5.multipliedReportingOverflow(by: 4), (UInt5(truncatingIfNeeded: (Int(v5) * 20) % 32), true))
        
        XCTAssertEqual(v1.dividedReportingOverflow(by: 1), (0, false))
        XCTAssertEqual(v2.dividedReportingOverflow(by: 3), (0, false))
        XCTAssertEqual(v3.dividedReportingOverflow(by: 13), (0, false))
        XCTAssertEqual(v3.dividedReportingOverflow(by: 21), (0, false))
        XCTAssertEqual(v4.dividedReportingOverflow(by: 5), (2, false))
        XCTAssertEqual(v5.dividedReportingOverflow(by: 4), (5, false))
        
        XCTAssertEqual(v1.remainderReportingOverflow(dividingBy: 1), (0, false))
        XCTAssertEqual(v2.remainderReportingOverflow(dividingBy: 3), (1, false))
        XCTAssertEqual(v3.remainderReportingOverflow(dividingBy: 13), (10, false))
        XCTAssertEqual(v3.remainderReportingOverflow(dividingBy: 21), (10, false))
        XCTAssertEqual(v4.remainderReportingOverflow(dividingBy: 5), (1, false))
        XCTAssertEqual(v5.remainderReportingOverflow(dividingBy: 4), (0, false))
        
        XCTAssertEqual(v1.multipliedFullWidth(by: 0), (0, 0))
        XCTAssertEqual(v2.multipliedFullWidth(by: 3), (0, 3))
        XCTAssertEqual(v3.multipliedFullWidth(by: 13), (4, 2))
        XCTAssertEqual(v3.multipliedFullWidth(by: 21), (6, 18))
        XCTAssertEqual(v4.multipliedFullWidth(by: 20), (6, 28))
        XCTAssertEqual(v5.multipliedFullWidth(by: 4), (2, 16))
        
        XCTAssertEqual(v2.dividingFullWidth((12, 22)), (UInt5(truncatingIfNeeded: 406), 0))
        XCTAssertEqual(v3.dividingFullWidth((12, 22)), (8, 6))
        XCTAssertEqual(v4.dividingFullWidth((12, 22)), (4, 10))
        XCTAssertEqual(v5.dividingFullWidth((12, 22)), (20, 6))

        XCTAssertEqual(v1.nonzeroBitCount, 0)
        XCTAssertEqual(v2.nonzeroBitCount, 1)
        XCTAssertEqual(v3.nonzeroBitCount, 2)
        XCTAssertEqual(v4.nonzeroBitCount, 3)
        XCTAssertEqual(v5.nonzeroBitCount, 2)

        XCTAssertEqual(v1.leadingZeroBitCount, 5)
        XCTAssertEqual(v2.leadingZeroBitCount, 4)
        XCTAssertEqual(v3.leadingZeroBitCount, 1)
        XCTAssertEqual(v4.leadingZeroBitCount, 1)
        XCTAssertEqual(v5.leadingZeroBitCount, 0)

        XCTAssertEqual(UInt5(bigEndian: 0), UInt5(0))
        XCTAssertEqual(UInt5(bigEndian: 1), UInt5(1))
        XCTAssertEqual(UInt5(bigEndian: 8), UInt5(8))
        XCTAssertEqual(UInt5(bigEndian: 13), UInt5(13))
        XCTAssertEqual(UInt5(bigEndian: 31), UInt5(31))

        XCTAssertEqual(UInt5(littleEndian: 0), UInt5(0))
        XCTAssertEqual(UInt5(littleEndian: 1), UInt5(1))
        XCTAssertEqual(UInt5(littleEndian: 8), UInt5(8))
        XCTAssertEqual(UInt5(littleEndian: 13), UInt5(13))
        XCTAssertEqual(UInt5(littleEndian: 31), UInt5(31))

        XCTAssertEqual(v1.bigEndian, v1)
        XCTAssertEqual(v2.bigEndian, v2)
        XCTAssertEqual(v3.bigEndian, v3)
        XCTAssertEqual(v4.bigEndian, v4)
        XCTAssertEqual(v5.bigEndian, v5)

        XCTAssertEqual(v1.littleEndian, v1)
        XCTAssertEqual(v2.littleEndian, v2)
        XCTAssertEqual(v3.littleEndian, v3)
        XCTAssertEqual(v4.littleEndian, v4)
        XCTAssertEqual(v5.littleEndian, v5)

        XCTAssertEqual(v1.byteSwapped, v1)
        XCTAssertEqual(v2.byteSwapped, v2)
        XCTAssertEqual(v3.byteSwapped, v3)
        XCTAssertEqual(v4.byteSwapped, v4)
        XCTAssertEqual(v5.byteSwapped, v5)

        XCTAssertShift(operands: &>>, &>>=, value: v4, shift: 0 as Int, expected: 0b01011)
        XCTAssertShift(operands: &>>, &>>=, value: v4, shift: 1 as UInt8, expected: 0b00101)
        XCTAssertShift(operands: &>>, &>>=, value: v4, shift: 3 as Int16, expected: 0b00001)
        XCTAssertShift(operands: &>>, &>>=, value: v4, shift: 4 as UInt5, expected: 0b00000)
        XCTAssertShift(operands: &>>, &>>=, value: v4, shift: 5 as UInt32, expected: 0b01011 >> 0)
        XCTAssertShift(operands: &>>, &>>=, value: v4, shift: 7 as Int8, expected: v4 >> 2)
        
        XCTAssertShift(operands: &<<, &<<=, value: v4, shift: 0 as Int, expected: 0b01011)
        XCTAssertShift(operands: &<<, &<<=, value: v4, shift: 1 as UInt8, expected: 0b10110)
        XCTAssertShift(operands: &<<, &<<=, value: v4, shift: 3 as Int16, expected: 0b11000)
        XCTAssertShift(operands: &<<, &<<=, value: v4, shift: 4 as UInt5, expected: 0b10000)
        XCTAssertShift(operands: &<<, &<<=, value: v4, shift: 5 as UInt32, expected: 0b01011 << 0)
        XCTAssertShift(operands: &<<, &<<=, value: v4, shift: 7 as Int8, expected: 0b01011 << 2)
        
        XCTAssertEqual(UInt5("0", radix: 10), 0)
        XCTAssertEqual(UInt5("1", radix: 10), 1)
        XCTAssertEqual(UInt5("10", radix: 10), 10)
        XCTAssertEqual(UInt5("11", radix: 10), 11)
        XCTAssertEqual(UInt5("20", radix: 10), 20)
        XCTAssertEqual(UInt5("31", radix: 10), 31)

        XCTAssertEqual(UInt5("0", radix: 2), 0)
        XCTAssertEqual(UInt5("1", radix: 2), 1)
        XCTAssertEqual(UInt5("10", radix: 2), 2)
        XCTAssertEqual(UInt5("11", radix: 2), 3)
        XCTAssertEqual(UInt5("11111", radix: 2), 31)
        XCTAssertEqual(UInt5("12", radix: 2), nil)

        XCTAssertEqual(UInt5("0", radix: 8), 0)
        XCTAssertEqual(UInt5("1", radix: 8), 1)
        XCTAssertEqual(UInt5("10", radix: 8), 8)
        XCTAssertEqual(UInt5("11", radix: 8), 9)
        XCTAssertEqual(UInt5("20", radix: 8), 16)
        XCTAssertEqual(UInt5("37", radix: 8), 31)
        XCTAssertEqual(UInt5("28", radix: 8), nil)

        XCTAssertEqual(UInt5("0", radix: 16), 0)
        XCTAssertEqual(UInt5("1", radix: 16), 1)
        XCTAssertEqual(UInt5("10", radix: 16), 16)
        XCTAssertEqual(UInt5("11", radix: 16), 17)
        XCTAssertEqual(UInt5("1F", radix: 16), 31)
        XCTAssertEqual(UInt5("1G", radix: 16), nil)

        XCTAssertEqual(UInt5("0"), 0)
        XCTAssertEqual(UInt5("1"), 1)
        XCTAssertEqual(UInt5("10"), 10)
        XCTAssertEqual(UInt5("11"), 11)
        XCTAssertEqual(UInt5("20"), 20)
        XCTAssertEqual(UInt5("31"), 31)
        XCTAssertEqual(UInt5("31x"), nil)

        XCTAssertEqual(v1.bitWidth, 5)
        XCTAssertEqual(v2.bitWidth, 5)
        XCTAssertEqual(v3.bitWidth, 5)
        XCTAssertEqual(v4.bitWidth, 5)
        XCTAssertEqual(v5.bitWidth, 5)
        
        var generator1 = FixedNumberGenerator(100)
        var generator2 = FixedNumberGenerator(30210)
        var generator3 = FixedNumberGenerator(1002040601)

        XCTAssertEqual(UInt5.random(in: 0..<5, using: &generator1), 1)
        XCTAssertEqual(UInt5.random(in: 0..<5, using: &generator2), 0)
        XCTAssertEqual(UInt5.random(in: 0..<5, using: &generator3), 0)
        
        XCTAssertEqual(UInt5.random(in: 8..<13, using: &generator1), 9)
        XCTAssertEqual(UInt5.random(in: 8..<13, using: &generator2), 8)
        XCTAssertEqual(UInt5.random(in: 8..<13, using: &generator3), 8)

        XCTAssertEqual(UInt5.random(in: 12..<31, using: &generator1), 19)
        XCTAssertEqual(UInt5.random(in: 12..<31, using: &generator2), 12)
        XCTAssertEqual(UInt5.random(in: 12..<31, using: &generator3), 13)

        XCTAssertEqual(UInt5.random(in: 0...5, using: &generator1), 2)
        XCTAssertEqual(UInt5.random(in: 0...5, using: &generator2), 0)
        XCTAssertEqual(UInt5.random(in: 0...5, using: &generator3), 0)
        
        XCTAssertEqual(UInt5.random(in: 8...13, using: &generator1), 10)
        XCTAssertEqual(UInt5.random(in: 8...13, using: &generator2), 8)
        XCTAssertEqual(UInt5.random(in: 8...13, using: &generator3), 8)

        XCTAssertEqual(UInt5.random(in: 12...31, using: &generator1), 19)
        XCTAssertEqual(UInt5.random(in: 12...31, using: &generator2), 12)
        XCTAssertEqual(UInt5.random(in: 12...31, using: &generator3), 13)

    }
}
