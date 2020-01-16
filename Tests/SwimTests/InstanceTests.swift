//
//  InstanceTests.swift
//  SwimTests
//
//  Created by Tomohiro Kumagai on 2020/01/16.
//

import XCTest
@testable import Swim

class InstanceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testApply() {
        
        let array1 = instanceApplyingExpression(with: Array<Int>()) { item in
            
            item.append(1)
            item.append(2)
            
            XCTAssertEqual(item.count, 2)
        }
        
        XCTAssertEqual(array1.count, 2)

        let obj1 = applyingExpression(to: NSMutableArray()) {
    
            $0.add(1)
            $0.add(2)
            $0.add(3)
            
            XCTAssertEqual($0.count, 3)
        }
        
        XCTAssertEqual(obj1.count, 3)

        
        var array2 = Array<Int>()
        
        applyingExpression(into: &array2) {
            
            $0.append(1)
            $0.append(2)
            $0.append(3)
            $0.append(4)
            
            XCTAssertEqual($0.count, 4)
        }
        
        XCTAssertEqual(array2.count, 4)
    }
}
