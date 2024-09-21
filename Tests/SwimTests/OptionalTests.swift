//
//  OptionalTests.swift
//  Swim
//  
//  Created by Tomohiro Kumagai on 2024/09/21
//  
//

import XCTest
@testable import Swim

final class OptionalTests: XCTestCase {

    func testMakingNilValueOfGenericType() throws {
        
        let stringValue: (some StringProtocol)? = nilValue(for: String.self)
        let intValue: (some BinaryInteger)? = nilValue(for: Int.self)
        
        XCTAssertNil(stringValue)
        XCTAssertNil(intValue)
    }
}
