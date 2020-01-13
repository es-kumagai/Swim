//
//  StateTests.swift
//  SwimTests
//
//  Created by Tomohiro Kumagai on 2020/01/13.
//

import XCTest
@testable import Swim

class StateTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProcessExitStatus() {

        let pass = 0 as ProcessExitStatus
        let abort1 = 1 as ProcessExitStatus
        let abort2 = ProcessExitStatus(code: 25)
        let abort3 = -1 as ProcessExitStatus
        
        XCTAssertTrue(pass.passed)
        XCTAssertFalse(pass.aborted)
        XCTAssertFalse(abort1.passed)
        XCTAssertTrue(abort1.aborted)
        XCTAssertFalse(abort2.passed)
        XCTAssertTrue(abort2.aborted)
        XCTAssertFalse(abort3.passed)
        XCTAssertTrue(abort3.aborted)
        
        XCTAssertTrue(0.meansProcessPassed)
        XCTAssertFalse(0.meansProcessAborted)
        XCTAssertFalse(1.meansProcessPassed)
        XCTAssertTrue(1.meansProcessAborted)
        
        XCTAssertEqual(abort2.code, 25)
        
        XCTAssertEqual(ProcessExitStatus.passed.code, 0)
        XCTAssertTrue(ProcessExitStatus.passed.passed)
        XCTAssertFalse(ProcessExitStatus.passed.aborted)
    }
    
    func testComparisonState() {
        
        let state1 = ComparisonState(representedBy: 0)
        let state2 = ComparisonState(representedBy: 1)
        let state3 = ComparisonState(representedBy: -1)
        let state4 = ComparisonState(representedBy: 1353)
        let state5 = ComparisonState(representedBy: -231)
        
        XCTAssertTrue(state1.isSame)
        XCTAssertFalse(state1.isAscending)
        XCTAssertFalse(state1.isDescending)
        XCTAssertTrue(state1.isAscendingOrSame)
        XCTAssertTrue(state1.isDescendingOrSame)
        
        XCTAssertFalse(state2.isSame)
        XCTAssertTrue(state2.isAscending)
        XCTAssertFalse(state2.isDescending)
        XCTAssertTrue(state2.isAscendingOrSame)
        XCTAssertFalse(state2.isDescendingOrSame)
        
        XCTAssertFalse(state3.isSame)
        XCTAssertFalse(state3.isAscending)
        XCTAssertTrue(state3.isDescending)
        XCTAssertFalse(state3.isAscendingOrSame)
        XCTAssertTrue(state3.isDescendingOrSame)
        
        XCTAssertFalse(state4.isSame)
        XCTAssertTrue(state4.isAscending)
        XCTAssertFalse(state4.isDescending)
        XCTAssertTrue(state4.isAscendingOrSame)
        XCTAssertFalse(state4.isDescendingOrSame)
        
        XCTAssertFalse(state5.isSame)
        XCTAssertFalse(state5.isAscending)
        XCTAssertTrue(state5.isDescending)
        XCTAssertFalse(state5.isAscendingOrSame)
        XCTAssertTrue(state5.isDescendingOrSame)
        
        XCTAssertTrue(0.meansOrderedSame)
        XCTAssertFalse(0.meansOrderedAscending)
        XCTAssertFalse(0.meansOrderedDescending)
        XCTAssertTrue(0.meansOrderedAscendingOrSame)
        XCTAssertTrue(0.meansOrderedDescendingOrSame)
        
        XCTAssertFalse(100.meansOrderedSame)
        XCTAssertTrue(100.meansOrderedAscending)
        XCTAssertFalse(100.meansOrderedDescending)
        XCTAssertTrue(100.meansOrderedAscendingOrSame)
        XCTAssertFalse(100.meansOrderedDescendingOrSame)
        
        XCTAssertFalse((-100).meansOrderedSame)
        XCTAssertFalse((-100).meansOrderedAscending)
        XCTAssertTrue((-100).meansOrderedDescending)
        XCTAssertFalse((-100).meansOrderedAscendingOrSame)
        XCTAssertTrue((-100).meansOrderedDescendingOrSame)
    }

    static var allTests = [
        ("testProcessExitStatus", testProcessExitStatus),
        ("testComparisonState", testComparisonState),
    ]
}
