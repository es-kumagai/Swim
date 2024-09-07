//
//  StringTests.swift
//  
//  
//  Created by Tomohiro Kumagai on 2024/09/07
//  
//

import XCTest

final class StringTests: XCTestCase {

    func testRemoveTrailingNewline() throws {
        
        var text1 = "ABCDE"
        var text2 = "ABCDE\n"
        var text3 = "あいうえお"
        var text4 = "あいうえお\n"
        var text5 = "\nABCDE"
        var text6 = "\nABCDE\n"
        var text7 = "あいうえお\n\n"
        var text8 = "あいうえお\n\n\n"

        var subtext1 = text1.dropLast(0)
        var subtext2 = text2.dropLast(0)
        var subtext3 = text3.dropLast(0)
        var subtext4 = text4.dropLast(0)
        var subtext5 = text5.dropLast(0)
        var subtext6 = text6.dropLast(0)
        var subtext7 = text7.dropLast(0)
        var subtext8 = text8.dropLast(0)

        XCTAssertFalse(text1.endsWithNewline, "\(text1) ends without newline.")
        XCTAssertTrue(text2.endsWithNewline, "\(text2) ends with newline.")
        XCTAssertFalse(text3.endsWithNewline, "\(text3) ends without newline.")
        XCTAssertTrue(text4.endsWithNewline, "\(text4) ends with newline.")
        XCTAssertFalse(text5.endsWithNewline, "\(text5) ends without newline.")
        XCTAssertTrue(text6.endsWithNewline, "\(text6) ends with newline.")
        XCTAssertTrue(text7.endsWithNewline, "\(text7) ends with newline.")
        XCTAssertTrue(text8.endsWithNewline, "\(text8) ends with newline.")

        XCTAssertFalse(subtext1.endsWithNewline, "\(subtext1) ends without newline.")
        XCTAssertTrue(subtext2.endsWithNewline, "\(subtext2) ends with newline.")
        XCTAssertFalse(subtext3.endsWithNewline, "\(subtext3) ends without newline.")
        XCTAssertTrue(subtext4.endsWithNewline, "\(subtext4) ends with newline.")
        XCTAssertFalse(subtext5.endsWithNewline, "\(subtext5) ends without newline.")
        XCTAssertTrue(subtext6.endsWithNewline, "\(subtext6) ends with newline.")
        XCTAssertTrue(subtext7.endsWithNewline, "\(subtext7) ends with newline.")
        XCTAssertTrue(subtext8.endsWithNewline, "\(subtext8) ends with newline.")

        let removedText1 = text1.removingTrailingNewline()
        let removedText2 = text2.removingTrailingNewline()
        let removedText3 = text3.removingTrailingNewline()
        let removedText4 = text4.removingTrailingNewline()
        let removedText5 = text5.removingTrailingNewline()
        let removedText6 = text6.removingTrailingNewline()
        let removedText7 = text7.removingTrailingNewline()
        let removedText8 = text8.removingTrailingNewline()
        
        let removedSubtext1 = subtext1.removingTrailingNewline()
        let removedSubtext2 = subtext2.removingTrailingNewline()
        let removedSubtext3 = subtext3.removingTrailingNewline()
        let removedSubtext4 = subtext4.removingTrailingNewline()
        let removedSubtext5 = subtext5.removingTrailingNewline()
        let removedSubtext6 = subtext6.removingTrailingNewline()
        let removedSubtext7 = subtext7.removingTrailingNewline()
        let removedSubtext8 = subtext8.removingTrailingNewline()
        
        XCTAssertEqual(removedText1, "ABCDE")
        XCTAssertEqual(removedText2, "ABCDE")
        XCTAssertEqual(removedText3, "あいうえお")
        XCTAssertEqual(removedText4, "あいうえお")
        XCTAssertEqual(removedText5, "\nABCDE")
        XCTAssertEqual(removedText6, "\nABCDE")
        XCTAssertEqual(removedText7, "あいうえお\n")
        XCTAssertEqual(removedText8, "あいうえお\n\n")
        
        XCTAssertEqual(removedSubtext1, "ABCDE")
        XCTAssertEqual(removedSubtext2, "ABCDE")
        XCTAssertEqual(removedSubtext3, "あいうえお")
        XCTAssertEqual(removedSubtext4, "あいうえお")
        XCTAssertEqual(removedSubtext5, "\nABCDE")
        XCTAssertEqual(removedSubtext6, "\nABCDE")
        XCTAssertEqual(removedSubtext7, "あいうえお\n")
        XCTAssertEqual(removedSubtext8, "あいうえお\n\n")
        
        XCTAssertFalse(text1.removeTrailingNewline(), "\(text1) ends with newline.")
        XCTAssertTrue(text2.removeTrailingNewline(), "\(text2) ends without newline.")
        XCTAssertFalse(text3.removeTrailingNewline(), "\(text3) ends with newline.")
        XCTAssertTrue(text4.removeTrailingNewline(), "\(text4) ends without newline.")
        XCTAssertFalse(text5.removeTrailingNewline(), "\(text5) ends with newline.")
        XCTAssertTrue(text6.removeTrailingNewline(), "\(text6) ends without newline.")
        XCTAssertTrue(text7.removeTrailingNewline(), "\(text7) ends without newline.")
        XCTAssertTrue(text8.removeTrailingNewline(), "\(text8) ends without newline.")
        
        XCTAssertFalse(subtext1.removeTrailingNewline(), "\(subtext1) ends with newline.")
        XCTAssertTrue(subtext2.removeTrailingNewline(), "\(subtext2) ends without newline.")
        XCTAssertFalse(subtext3.removeTrailingNewline(), "\(subtext3) ends with newline.")
        XCTAssertTrue(subtext4.removeTrailingNewline(), "\(subtext4) ends without newline.")
        XCTAssertFalse(subtext5.removeTrailingNewline(), "\(subtext5) ends with newline.")
        XCTAssertTrue(subtext6.removeTrailingNewline(), "\(subtext6) ends without newline.")
        XCTAssertTrue(subtext7.removeTrailingNewline(), "\(subtext7) ends without newline.")
        XCTAssertTrue(subtext8.removeTrailingNewline(), "\(subtext8) ends without newline.")
        
        XCTAssertEqual(text1, removedText1)
        XCTAssertEqual(text2, removedText2)
        XCTAssertEqual(text3, removedText3)
        XCTAssertEqual(text4, removedText4)
        XCTAssertEqual(text5, removedText5)
        XCTAssertEqual(text6, removedText6)
        XCTAssertEqual(text7, removedText7)
        XCTAssertEqual(text8, removedText8)
        
        XCTAssertEqual(subtext1, removedSubtext1)
        XCTAssertEqual(subtext2, removedSubtext2)
        XCTAssertEqual(subtext3, removedSubtext3)
        XCTAssertEqual(subtext4, removedSubtext4)
        XCTAssertEqual(subtext5, removedSubtext5)
        XCTAssertEqual(subtext6, removedSubtext6)
        XCTAssertEqual(subtext7, removedSubtext7)
        XCTAssertEqual(subtext8, removedSubtext8)
        
        XCTAssertFalse(text1.endsWithNewline, "Expected the text to have no trailing newline, but it still has one.")
        XCTAssertFalse(text2.endsWithNewline, "Expected the text to have no trailing newline, but it still has one.")
        XCTAssertFalse(text3.endsWithNewline, "Expected the text to have no trailing newline, but it still has one.")
        XCTAssertFalse(text4.endsWithNewline, "Expected the text to have no trailing newline, but it still has one.")
        XCTAssertFalse(text5.endsWithNewline, "Expected the text to have no trailing newline, but it still has one.")
        XCTAssertFalse(text6.endsWithNewline, "Expected the text to have no trailing newline, but it still has one.")
        XCTAssertEqual(text7.suffix(3), "えお\n", "Expected the text was removed a trailing newline.")
        XCTAssertEqual(text8.suffix(3), "お\n\n", "Expected the text was removed a trailing newline.")
        
        XCTAssertFalse(subtext1.endsWithNewline, "Expected the text to have no trailing newline, but it still has one.")
        XCTAssertFalse(subtext2.endsWithNewline, "Expected the text to have no trailing newline, but it still has one.")
        XCTAssertFalse(subtext3.endsWithNewline, "Expected the text to have no trailing newline, but it still has one.")
        XCTAssertFalse(subtext4.endsWithNewline, "Expected the text to have no trailing newline, but it still has one.")
        XCTAssertFalse(subtext5.endsWithNewline, "Expected the text to have no trailing newline, but it still has one.")
        XCTAssertFalse(subtext6.endsWithNewline, "Expected the text to have no trailing newline, but it still has one.")
        XCTAssertEqual(subtext7.suffix(3), "えお\n", "Expected the text was removed a trailing newline.")
        XCTAssertEqual(subtext8.suffix(3), "お\n\n", "Expected the text was removed a trailing newline.")
    }
}
