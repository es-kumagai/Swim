//
//  StateTests.swift
//  SwimTests
//
//  Created by Tomohiro Kumagai on 2020/01/13.
//

import XCTest
@testable import Swim

struct MyValue {
    
    var rawValue: String
}

struct MyRecord : SQLite3Translateable {

    static var sqlite3Columns: [Column] = [
        
    ]
    
    static let sqlite3DefaultValue = MyRecord()
    
    var value: MyValue = MyValue(rawValue: "")
}

extension MyValue : SQLite3ValueCompatible {

    static let acceptsSQLiteNull = false
    static let declaredSQLiteType = SQLite3.DefineDataType.text
    var actualSQLiteType: SQLite3.ActualDataType { .text }
    var sqliteValue: SQLite3.Value { .text(rawValue) }
    
    var integerValue: Int? { nil }
    var realValue: Double? { nil }
    var textValue: String? { rawValue }
    var isNull: Bool { false }
    
    init?(_ value: SQLite3.Value) {

        guard let text = value.textValue else {
            
            return nil
        }

        self.init(rawValue: text)
    }
}

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
    
    func testComparison() {
        
        let state1 = Comparison(representedBy: 0)
        let state2 = Comparison(representedBy: 1)
        let state3 = Comparison(representedBy: -1)
        let state4 = Comparison(representedBy: 1353)
        let state5 = Comparison(representedBy: -231)
        let state6 = compare(100, 100)
        let state7 = compare(100, -35)
        let state8 = compare(100, 138)
        
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

        XCTAssertTrue(state6.isSame)
        XCTAssertFalse(state6.isAscending)
        XCTAssertFalse(state6.isDescending)
        XCTAssertTrue(state6.isAscendingOrSame)
        XCTAssertTrue(state6.isDescendingOrSame)

        XCTAssertFalse(state7.isSame)
        XCTAssertFalse(state7.isAscending)
        XCTAssertTrue(state7.isDescending)
        XCTAssertFalse(state7.isAscendingOrSame)
        XCTAssertTrue(state7.isDescendingOrSame)

        XCTAssertFalse(state8.isSame)
        XCTAssertTrue(state8.isAscending)
        XCTAssertFalse(state8.isDescending)
        XCTAssertTrue(state8.isAscendingOrSame)
        XCTAssertFalse(state8.isDescendingOrSame)
    }
    
    func testColumn() throws {
        
        let column1 = SQLite3.ColumnMetadata("value", keyPath: \MyRecord.value)
        
        XCTAssertEqual(column1.field.name, "value")
    }

    func testContinuousState() {
        
        XCTAssertTrue(ProcessExitStatus(representedBy: Continuous.continue).passed)
        XCTAssertFalse(ProcessExitStatus(representedBy: Continuous.continue).aborted)
        XCTAssertFalse(ProcessExitStatus(representedBy: Continuous.abort).passed)
        XCTAssertTrue(ProcessExitStatus(representedBy: Continuous.abort).aborted)
    }
    
    static var allTests = [
        ("testProcessExitStatus", testProcessExitStatus),
        ("testComparison", testComparison),
        ("testContinuousState", testContinuousState),
    ]
}
