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

    func testBase32Encode() throws {

        let text1 = "Hello!"
        let text2 = "EZ-NET"
        let text3 = "API Design Guidelines"

        let encoded1 = Base32.encodingAsCString(text1)
        let encoded2 = Base32.encodingAsCString(text2)
        let encoded3 = Base32.encodingAsCString(text3)

        XCTAssertEqual(encoded1, "JBSWY3DPEE======")
        XCTAssertEqual(encoded2, "IVNC2TSFKQ======")
        XCTAssertEqual(encoded3, "IFIESICEMVZWSZ3OEBDXK2LEMVWGS3TFOM======")
    }
    
    func testBase32Decode() throws {
        
        let encoded1 = "JBSWY3DPEE======"
        let encoded2 = "IVNC2TSFKQ======"
        let encoded3 = "IFIESICEMVZWSZ3OEBDXK2LEMVWGS3TFOM======"

        let decoded1 = Base32.decodingAsCString(encoded1)
        let decoded2 = Base32.decodingAsCString(encoded2)
        let decoded3 = Base32.decodingAsCString(encoded3)

        XCTAssertEqual(decoded1, "Hello!")
        XCTAssertEqual(decoded2, "EZ-NET")
        XCTAssertEqual(decoded3, "API Design Guidelines")
    }
}
