//
//  CSVTests.swift
//  SwimTests
//
//  Created by Tomohiro Kumagai on 2020/12/09.
//

import XCTest
@testable import Swim

private struct Column : CSVColumnConvertible, Equatable {

    var value: Int

    init(value: Int) {
        self.value = value
    }
    
    init?(csvDescription: String) {
        
        guard csvDescription.hasPrefix("0x") else {
            return nil
        }

        guard let value = Int(csvDescription.dropFirst(2), radix: 16) else {
            return nil
        }
        
        self.value = value
    }
    
    var csvDescription: String {

        "0x" + String(value, radix: 16)
    }
}

private struct CSVValue {
    
    var name: String
    var price: Int
    var taxRate: Double?
    var note: String?
    var column: Column
}

extension CSVValue : Equatable {
    
}

extension CSVValue : CSVLineConvertible {
    
    init(_ value: Self) {
        
        self = value
    }

    @CSV.ColumnDeclaration
    static var csvColumns: [CSVColumn] {
        
        CSVColumn("name", keyPath: \.name)
        CSVColumn("price", keyPath: \.price)
        CSVColumn("tax rate", keyPath: \.taxRate)
        CSVColumn("note", keyPath: \.note)
        CSVColumn("column", keyPath: \.column)
    }
    
    static private(set) var csvDefaultValue = CSVValue(name: "", price: 0, taxRate: 0, column: Column(value: 0))
}

private struct DoubleString {
    
    var a: String
    var b: String
}

extension DoubleString : CSVLineConvertible {
    
    @CSV.ColumnDeclaration
    static var csvColumns: [CSVColumn] {
        
        CSVColumn("a", keyPath: \.a)
        CSVColumn("b", keyPath: \.b)
    }
    
    static let csvDefaultValue = DoubleString(a: "A", b: "B")
    
    init(_ value: DoubleString) {
        
        self = value
    }
}

class CSVTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFunctions() throws {
    
        let string1 = "abc\"def"
        let string2 = "\"abcdef\""
        let string3 = "\"abc\"\"def\""
        
        XCTAssertEqual(CSV.quoteWord, "\"")
        XCTAssertEqual(CSV.separator, ",")
        
        XCTAssertFalse(CSV.isQuoted(string1))
        XCTAssertTrue(CSV.isQuoted(string2))
        XCTAssertTrue(CSV.isQuoted(string3))
        XCTAssertEqual(CSV.extracted(string1), nil)
        XCTAssertEqual(CSV.extracted(string2), "abcdef")
        XCTAssertEqual(CSV.extracted(string3), "abc\"def")
        XCTAssertEqual(CSV.quoted(string1), "\"abc\"\"def\"")
        XCTAssertEqual(CSV.quoted(string2), "\"\"\"abcdef\"\"\"")
        XCTAssertEqual(CSV.quoted(string3), "\"\"\"abc\"\"\"\"def\"\"\"")
        
        let parts = CSV.split(#"abc,d"ef , "ghi,"jk\nlm","no""pqr""#)
        
        XCTAssertEqual(parts, [#"abc"#, #"d"ef "#, #" "ghi"#, #""jk\nlm""#, #""no"pqr""#])
    }
    
    func testColumns() throws {

        let columns = CSVValue.csvColumns
        
        XCTAssertEqual(columns.map(\.name), ["name", "price", "tax rate", "note", "column"])
        XCTAssertEqual(columns.map(\.keyPath), [\CSVValue.name, \CSVValue.price, \CSVValue.taxRate, \CSVValue.note, \CSVValue.column])
        XCTAssertEqual(columns.map(\.debugDescription), ["name: String", "price: Int", "tax rate: Optional<Double>", "note: Optional<String>", "column: Column"])
        XCTAssertTrue(columns.map(\.datatype)[0] == String.self)
        XCTAssertTrue(columns.map(\.datatype)[1] == Int.self)
        XCTAssertTrue(columns.map(\.datatype)[2] == Optional<Double>.self)
        XCTAssertTrue(columns.map(\.datatype)[3] == Optional<String>.self)
        
        XCTAssertEqual(10.csvDescription, "10")
        XCTAssertEqual("X".csvDescription, "\"X\"")
        XCTAssertEqual("".csvDescription, "\"\"")
        XCTAssertEqual(("X" as String?).csvDescription, "\"X\"")
        XCTAssertEqual((nil as String?).csvDescription, "")
        
        XCTAssertEqual(String(csvDescription: ""), "")
        XCTAssertEqual(Int(csvDescription: ""), nil)
        XCTAssertEqual(Double(csvDescription: ""), nil)
        XCTAssertEqual(String?(csvDescription: ""), .some(nil))
        XCTAssertEqual(String?(csvDescription: ""), nil as String?)
    }
    
    func testLines() throws {
        
        let value1a = CSVValue(name: "item", price: 102, taxRate: 1.05, note: "NOTE", column: Column(value: 15))
        let value1b = CSVValue(name: "item", price: 102, taxRate: 1.05, note: "", column: Column(value: 16))
        let value2a = CSVValue(name: "goods", price: 1200, taxRate: nil, note: nil, column: Column(value: 255))
        let value2b = CSVValue(name: "goods", price: 1200, taxRate: nil, note: "", column: Column(value: 256))

        let csv1a = value1a.toCSVLine()
        let csv1b = value1b.toCSVLine()
        let csv2a = value2a.toCSVLine()
        let csv2b = value2b.toCSVLine()

        XCTAssertEqual(CSVValue.csvHeaderLine, #""name","price","tax rate","note","column""# + "\n")
        
        XCTAssertEqual(csv1a, #""item",102,1.05,"NOTE",0xf"# + "\n")
        XCTAssertEqual(csv1b, #""item",102,1.05,"",0x10"# + "\n")
        XCTAssertEqual(csv2a, #""goods",1200,,,0xff"# + "\n")
        XCTAssertEqual(csv2b, #""goods",1200,,"",0x100"# + "\n")
        
        let value1c = try CSVValue(csvLine: csv1a)
        let value1d = try CSVValue(csvLine: csv1b)
        let value2c = try CSVValue(csvLine: csv2a)
        let value2d = try CSVValue(csvLine: csv2b)
        
        XCTAssertEqual(value1a, value1c)
        XCTAssertEqual(value1b, value1d)
        XCTAssertEqual(value2a, value2c)
        XCTAssertEqual(value2b, value2d)
        
        let value = DoubleString(a: "H", b: "L")
        let csv = value.toCSVLine()
        let reValue = try DoubleString(csvLine: csv)

        XCTAssertEqual(csv, #""H","L"\#n"#)
        XCTAssertEqual(reValue.a, value.a)
        XCTAssertEqual(reValue.b, value.b)
    }
}
