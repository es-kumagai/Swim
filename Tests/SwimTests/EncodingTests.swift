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
    
    func testPadding() throws {
        
        let encodedString1 = "2A6H5LW5GZ5TKO64UKGPT5QTPQNECHBV"
        let encodedString2 = "2A6H5LW5GZ5TKO64UKGPT5QTPQNECHBVOLA4M"

        let decodedBytes1 = Base32.decoding(encodedString1)!
        let reEncodedString1 = Base32.encodingAsCString(decodedBytes1)

        let decodedBytes2 = Base32.decoding(encodedString2)!
        let reEncodedString2 = Base32.encodingAsCString(decodedBytes2)

        XCTAssertEqual(decodedBytes1, [0xD0, 0x3C, 0x7E, 0xAE, 0xDD, 0x36, 0x7B, 0x35, 0x3B, 0xDC, 0xA2, 0x8C, 0xF9, 0xF6, 0x13, 0x7C, 0x1A, 0x41, 0x1C, 0x35])
        XCTAssertEqual(decodedBytes2, [0xD0, 0x3C, 0x7E, 0xAE, 0xDD, 0x36, 0x7B, 0x35, 0x3B, 0xDC, 0xA2, 0x8C, 0xF9, 0xF6, 0x13, 0x7C, 0x1A, 0x41, 0x1C, 0x35, 0x72, 0xC1, 0xC6])

        XCTAssertEqual("\(encodedString1)", reEncodedString1)
        XCTAssertEqual("\(encodedString2)===", reEncodedString2)
    }

}
