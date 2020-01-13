//
//  CollectionSearchTests.swift
//  SwimTests
//
//  Created by Tomohiro Kumagai on 2020/01/13.
//

import XCTest

class CollectionManageTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIndexesWhere() {
        
        let sampleA = [34, 32, 21, 4, 7, 45, 23, 53, 45]
        let sampleB = [7, 52, 23, 41, 7, 4, 34, 15]
        
        let target = [4, 7, 23, 45]
        
        XCTAssertEqual(sampleA.indexes(of: target), [3, 4, 5, 6, 8])
        XCTAssertEqual(sampleB.indexes(of: target), [0, 2, 4, 5])
    }
    
    func testDistinct() {
        
        let elements = [1, 3, 7, 5, 4 ,3, 8, 7, 0]
        let distinctElements = elements.uniqued()
        
        let expectedItem = [1, 3, 7, 5, 4, 8, 0]
        
        XCTAssertEqual(distinctElements, expectedItem)
    }
    
    func testIndexesByPredicate() {
        
        let elements = [1, 23, 2, 12, 3, 135, 13]
        
        let indexes = elements.indexes {
            
            $0 > 20
        }
        
        let expectedIndexes = [
            
            elements.startIndex.advanced(by: 1),
            elements.startIndex.advanced(by: 5)
        ]
        
        XCTAssertEqual(indexes, expectedIndexes)
    }
    
    func testRemoveIndexes() {
        
        var items = [1, 23, 2, 12, 3, 135, 13]        
        let indexes = [0, 3, 5, 6]
        
        items.remove(contentsAt: indexes)
        
        XCTAssertEqual(items, [23, 2, 3])
    }
    
    static var allTests = [
        ("testIndexesWhere", testIndexesWhere),
        ("testDistinct", testDistinct),
        ("testIndexesByPredicate", testIndexesByPredicate),
        ("testRemoveIndexes", testRemoveIndexes),
    ]
}
