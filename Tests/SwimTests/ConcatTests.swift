//
//  ConcatTests.swift
//  SwimTests
//
//  Created by Tomohiro Kumagai on 2021/02/14.
//

import XCTest
@testable import Swim

class ConcatTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testConcatenateString() throws {

        let string1 = "AB"
        let string2 = "BC"
        let string3 = "CD"
        let strings = ["DE", "EF", "FG"]
        
        let condition = 0
        
        let test0 = String.concat {
            
        }
        
        let test1 = String.concat {
            
            string1
            string2
        }

        let test2 = String.concat {

            string1

            if condition == 0 {
            
                string3
            }
            
            string2
        }

        let test3 = String.concat {

            string1

            switch condition {

            case 0:
                string3

            default:
                nil as String?
            }

            string2
        }
        
        let test4 = String.concat {
            
            string1
            string2
            strings
        }
        
        let test5 = String.concat {
            
            string1
            string2
            
            for string in strings {
                
                string.lowercased()
            }
            
            string3
        }
        
        XCTAssertEqual(test0, "")
        XCTAssertEqual(test1, "ABBC")
        XCTAssertEqual(test2, "ABCDBC")
        XCTAssertEqual(test3, "ABCDBC")
        XCTAssertEqual(test4, "ABBCDEEFFG")
        XCTAssertEqual(test5, "ABBCdeeffgCD")
    }
    
    func testStringConcatWithNewline() throws {
    
        @StringConcatWithNewline
        func make1() -> String {
            "A"
            "BC"
            ""
            "DE"
            nil
            "F"
        }
        
        let string1 = make1()
        
        XCTAssertEqual(string1, "A\nBC\n\nDE\n\nF\n")
    }
    
    func testConcatenateArray() throws {

        let array1 = [1, 2]
        let array2 = [2, 3]
        let array3 = [3, 4]
        let array4 = [7, 8, 9]
        
        let condition = 0
        
        let test0 = Array<Int>.bundle {
            
        }
        
        let test1 = Array<Int>.bundle {
            
            array1
            array2
        }

        let test2 = Array<Int>.bundle {

            array1

            if condition == 0 {
            
                array3
            }
            
            array2
        }

        let test3 = Array<Int>.bundle {

            array1

            switch condition {

            case 0:
                array3

            default:
                nil as Int?
            }

            array2
        }
        
        let test4 = Array<Int>.bundle {
            
            array1
            array2
            array4
        }
        
        let test5 = Array<Int>.bundle {
            
            array1
            array2
            
            for array in array4 {
                
                array - 1
            }
            
            array3
        }
        
        XCTAssertEqual(test0, [])
        XCTAssertEqual(test1, [1, 2, 2, 3])
        XCTAssertEqual(test2, [1, 2, 3, 4, 2, 3])
        XCTAssertEqual(test3, [1, 2, 3, 4, 2, 3])
        XCTAssertEqual(test4, [1, 2, 2, 3, 7, 8, 9])
        XCTAssertEqual(test5, [1, 2, 2, 3, 6, 7, 8, 3, 4])
    }
}
