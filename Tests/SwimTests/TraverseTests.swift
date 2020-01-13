//
//  TraverseTests.swift
//  SwimTests
//
//  Created by Tomohiro Kumagai on 2020/01/13.
//

import XCTest

class TraverseTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMeets() {
    
        let value1 = [ 1, 3, 10, 8, 23, 31, 10, 5, 1 ]
        let value2 = [ 4, 24, 2, 13, 10, 8, 18, 12, 0 ]
        
        XCTAssertTrue(value1.meetsAll { $0 > 0 })
        XCTAssertFalse(value1.meetsAll { $0 > 1 })
        XCTAssertTrue(value2.meetsAll { $0 < 30 })
        XCTAssertFalse(value2.meetsAll { $0 < 20 })
        
        XCTAssertTrue(value1.meetsAny { $0 == 10 })
        XCTAssertFalse(value1.meetsAny { $0 < 0 })
        XCTAssertTrue(value2.meetsAny { $0 > 0 })
        XCTAssertFalse(value2.meetsAny { $0 == 100 })
        
        XCTAssertTrue(value1.meetsNone { $0 < 0 })
        XCTAssertFalse(value1.meetsNone { $0 > 0 })
        XCTAssertTrue(value2.meetsNone { $0 > 24 })
        XCTAssertFalse(value2.meetsNone { $0 > 10 })
    }

    static var allTests = [
        ("testMeets", testMeets),
    ]}
