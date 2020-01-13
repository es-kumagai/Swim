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

    static var allTests = [
        ("testProcessExitStatus", testProcessExitStatus),
    ]
}
