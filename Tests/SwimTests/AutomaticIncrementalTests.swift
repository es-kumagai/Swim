//
//  AutomaticIncrementalTests.swift
//  
//  
//  Created by Tomohiro Kumagai on 2024/02/28
//  
//

import XCTest
@testable import Swim

final class AutomaticIncrementalTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAutomaticIncrement() throws {
        
        @AutomaticIncremental
        var seed = 0
        
        XCTAssertEqual(seed, 0)
        XCTAssertEqual(seed, 1)
        XCTAssertNotEqual(seed, 0)
        XCTAssertEqual(seed, 3)
        XCTAssertEqual(seed, 4)
        
        $seed.rewind()
        
        XCTAssertEqual(seed, 0)
        XCTAssertEqual(seed, 1)
        XCTAssertNotEqual(seed, 0)
        XCTAssertEqual(seed, 3)
        XCTAssertEqual(seed, 4)
    }
}
