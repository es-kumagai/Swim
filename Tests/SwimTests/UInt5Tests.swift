//
//  UInt5Tests.swift
//  
//  
//  Created by Tomohiro Kumagai on 2024/04/11
//  
//

import XCTest
@testable import Swim

final class UInt5Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasics() throws {
        
        XCTFail("Now implementing.")
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
        
    }
    
    func testStrideable() throws {
        
    }
    
    func testLiteralExpression() throws {
        
    }
    
    func testAdditiveArithmetic() throws {
        
    }
    
    func testNumeric() throws {
        
    }
    
    func testBinaryInteger() throws {
        
    }
    
    func testFixedWidthInteger() throws {
        
    }
}
