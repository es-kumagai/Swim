//
//  SeekTests.swift
//  Swim
//  
//  Created by Tomohiro Kumagai on 2024/09/13
//  
//

import XCTest
@testable import Swim

final class SeekTests: XCTestCase {

    func testSeek() throws {
        
        let text1 = "AAA BBB CCC DDD  EEE FFF"
        let text2 = "<1>AAA<2>BBB<3>CCC<E>ZZZ"
        
        let seek1 = text1.seeking(by: #/\s+/#)
        let seek2 = text2.seeking(by: #/\<\d\>/#, truncator: #/\<E\>/#)
        let seek3 = text1.seeking(by: #/\s+/#, removeMatching: true)

        XCTAssertEqual(Array(seek1), [" BBB", " CCC", " DDD", "  EEE", " FFF"])
        XCTAssertEqual(Array(seek2), ["<1>AAA", "<2>BBB", "<3>CCC"])
        XCTAssertEqual(Array(seek3), ["BBB", "CCC", "DDD", "EEE", "FFF"])
    }
}
