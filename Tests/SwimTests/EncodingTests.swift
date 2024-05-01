//
//  EncodingTests.swift
//  
//  
//  Created by Tomohiro Kumagai on 2024/03/24
//  
//

import XCTest
@testable import Swim

final class EncodingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBase32Decode() throws {
        
        let encoded1 = "JBSWY3DPEE======"
        let decoded1 = Base32.decodingAsCString(encoded1)
        
        XCTAssertEqual(decoded1, "Hello!")
    }
}
