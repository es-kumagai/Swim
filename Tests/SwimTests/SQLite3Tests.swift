//
//  SQLite3Tests.swift
//  SwimTests
//
//  Created by Tomohiro Kumagai on 2020/11/11.
//

import XCTest
@testable import Swim
import SQLite3

private struct MyData : SQLiteArrayElement {
    
    var id: Int
    var flags: Double?
    var name: String
    
    init() {
        
        id = 0
        name = ""
        flags = 0
    }
}

class SQLite3Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRead() throws {
        
        /**
         FIXME: WORKAROUND
         Now SwiftPM seems to copy resources for unit test to bundle.
         In addition, even if execute `swift test`, the resources cannot be found in `Bundle.module`.
         To find the resources, specify the resource's path directly. (not in bundle.)
         */
//        let path = Bundle(for: Self.self).path(forResource: "EZ-NET", ofType: "sqlite3")!
//        let path = Bundle.module.path(forResource: "EZ-NET", ofType: "sqlite3")!
        let path = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("Resources/EZ-NET.sqlite3").absoluteString
        print(path)
        
        let sqlite = try SQLite3(path: path, options: .readonly)
        
        XCTAssertThrowsError(try sqlite.execute(sql: "SELECT FROM Updates"))
        XCTAssertThrowsError(try sqlite.execute(sql: "SELECT * FROM Dummy"))

        let statement = try sqlite.makeStatement(with: "SELECT * FROM Updates WHERE UpdateID BETWEEN @idMin AND @idMax ORDER BY UpdateID") { statement in
            
            try statement.parameter("@idMin").bind(1178)
            try statement.parameter("@idMax").bind(1180)
        }
        
        XCTAssertEqual(statement.columnCount, 6)
        XCTAssertEqual(statement.columnNames, ["UpdateID", "State", "Caption", "Description", "URI", "DateTime"])

        XCTAssertTrue(try statement.step())

        XCTAssertEqual(statement.columns[0].type, .integer)
        XCTAssertEqual(statement.columns[1].type, .text)
        XCTAssertEqual(statement.columns[2].type, .text)
        XCTAssertEqual(statement.columns[3].type, .text)
        XCTAssertEqual(statement.columns[4].type, .text)
        XCTAssertEqual(statement.columns[5].type, .text)

        XCTAssertEqual(statement.columns[0].integerValue, 1178)
        XCTAssertEqual(statement.columns[2].textValue, "UISlider の値を操作する。")
        XCTAssertEqual(statement.columns[4].textValue, "/article/8A/3GTRi2tH/SYJ1jMo5TVWw/")
        XCTAssertEqual(statement.columns.UpdateID.integerValue, 1178)
        XCTAssertEqual(statement.columns.Caption.textValue, "UISlider の値を操作する。")
        XCTAssertEqual(statement.columns.URI.textValue, "/article/8A/3GTRi2tH/SYJ1jMo5TVWw/")

        XCTAssertTrue(try statement.step())
        
        XCTAssertEqual(statement.columns[0].integerValue, 1179)
        XCTAssertEqual(statement.columns[2].textValue, "UISwitch の値を操作する。")
        XCTAssertEqual(statement.columns[4].textValue, "/article/51/_SXHqIpL/zaKazZyqkneE/")
        XCTAssertEqual(statement.columns["UpdateID"].integerValue, 1179)
        XCTAssertEqual(statement.columns["Caption"].textValue, "UISwitch の値を操作する。")
        XCTAssertEqual(statement.columns["URI"].textValue, "/article/51/_SXHqIpL/zaKazZyqkneE/")

        XCTAssertTrue(try statement.step())

        XCTAssertEqual(statement.columns[0].integerValue, 1180)
        XCTAssertEqual(statement.columns[2].textValue, "UIScrollView をスクロールさせる。")
        XCTAssertEqual(statement.columns[4].textValue, "/article/51/KyIcnlBE/PadIz8Rd3cRa/")

        XCTAssertFalse(try statement.step())
    }
    
    func testWrite() throws {
        
        let sqlite = try SQLite3(store: .onMemory, options: .readwrite)
        
        XCTAssertEqual(sqlite.previousChanges, 0)
        
        try sqlite.execute(sql: "CREATE TABLE sample(id INTEGER NOT NULL PRIMARY KEY, name TEXT, flag REAL DEFAULT 1.5, dummy NULL)")
        XCTAssertEqual(sqlite.previousChanges, 0)

        let info = try sqlite.execute(sql: "PRAGMA table_info('sample')")!
        XCTAssertEqual(sqlite.previousChanges, 0)

        XCTAssertEqual(info.columnCount, 6)
        
        XCTAssertEqual(info.columns.cid.integerValue, 0)
        XCTAssertEqual(info.columns.name.textValue, "id")
        XCTAssertEqual(info.columns.type.textValue, "INTEGER")
        XCTAssertEqual(info.columns.notnull.integerValue, 1)
        XCTAssertTrue(info.columns.dflt_value.isNull)
        XCTAssertEqual(info.columns.pk.integerValue, 1)

        XCTAssertTrue(try info.step())
        
        XCTAssertEqual(info.columns.cid.integerValue, 1)
        XCTAssertEqual(info.columns.name.textValue, "name")
        XCTAssertEqual(info.columns.type.textValue, "TEXT")
        XCTAssertEqual(info.columns.notnull.integerValue, 0)
        XCTAssertTrue(info.columns.dflt_value.isNull)
        XCTAssertEqual(info.columns.pk.integerValue, 0)

        XCTAssertTrue(try info.step())
        
        XCTAssertEqual(info.columns.cid.integerValue, 2)
        XCTAssertEqual(info.columns.name.textValue, "flag")
        XCTAssertEqual(info.columns.type.textValue, "REAL")
        XCTAssertEqual(info.columns.notnull.integerValue, 0)
        XCTAssertEqual(info.columns.dflt_value.textValue, "1.5")
        XCTAssertEqual(info.columns.pk.integerValue, 0)

        XCTAssertTrue(try info.step())

        XCTAssertEqual(info.columns.cid.integerValue, 3)
        XCTAssertEqual(info.columns.name.textValue, "dummy")
        XCTAssertEqual(info.columns.type.textValue, "")
        XCTAssertEqual(info.columns.notnull.integerValue, 0)
        XCTAssertTrue(info.columns.dflt_value.isNull)
        XCTAssertEqual(info.columns.pk.integerValue, 0)

        XCTAssertFalse(try info.step())
        
        let st1 = try sqlite.execute(sql: "SELECT * FROM sample")
        XCTAssertEqual(sqlite.previousChanges, 0)

        XCTAssertNil(st1)
        
        try sqlite.execute(sql: "INSERT INTO sample (id, name, flag) VALUES (10, 'EZ-NET', 1.5), (22, 'ORIENT', NULL)")
        XCTAssertEqual(sqlite.previousChanges, 2)

        guard let st2 = try sqlite.execute(sql: "SELECT * FROM sample") else {
            
            XCTFail("Expect some data exists.")
            return
        }
        XCTAssertEqual(sqlite.previousChanges, 2)

        XCTAssertEqual(st2.columns.id.integerValue, 10)
        XCTAssertEqual(st2.columns.name.textValue, "EZ-NET")
        XCTAssertEqual(st2.columns.flag.realValue, 1.5)

        XCTAssertTrue(try st2.step())

        XCTAssertEqual(st2.columns.id.integerValue, 22)
        XCTAssertEqual(st2.columns.name.textValue, "ORIENT")
        XCTAssertEqual(st2.columns.flag.realValue, 0)

        XCTAssertFalse(try st2.step())

        let st3 = try sqlite.makeStatement(with: "SELECT * FROM sample ORDER BY id DESC")
        XCTAssertEqual(sqlite.previousChanges, 2)

        let values = st3.map {
            
            $0.columns.name.textValue
        }

        XCTAssertEqual(values, ["ORIENT", "EZ-NET"])
    }
    
    func testOpenOptions() throws {
        
        XCTAssertEqual(SQLite3.OpenOption.readonly.rawValue, SQLITE_OPEN_READONLY)
        XCTAssertEqual(SQLite3.OpenOption.readwrite.rawValue, SQLITE_OPEN_READWRITE)
        XCTAssertEqual(SQLite3.OpenOption.create.rawValue, SQLITE_OPEN_CREATE)
        XCTAssertEqual(SQLite3.OpenOption.uri.rawValue, SQLITE_OPEN_URI)
        XCTAssertEqual(SQLite3.OpenOption.memory.rawValue, SQLITE_OPEN_MEMORY)
        XCTAssertEqual(SQLite3.OpenOption.noMutex.rawValue, SQLITE_OPEN_NOMUTEX)
        XCTAssertEqual(SQLite3.OpenOption.fullMutex.rawValue, SQLITE_OPEN_FULLMUTEX)
        XCTAssertEqual(SQLite3.OpenOption.sharedCache.rawValue, SQLITE_OPEN_SHAREDCACHE)
        XCTAssertEqual(SQLite3.OpenOption.privateCache.rawValue, SQLITE_OPEN_PRIVATECACHE)
    }
    
    func testText() throws {
    
        XCTAssertEqual(SQLite3.quoted("TEXT"), "'TEXT'")
        XCTAssertEqual(SQLite3.fieldName("FIELD"), "\"FIELD\"")
        XCTAssertEqual(SQLite3.quoted("TE'XT"), "'TE''XT'")
        XCTAssertEqual(SQLite3.fieldName("FI\"ELD"), "\"FI\"\"ELD\"")
    }
    
    func testArray() throws {
                
        let array = try SQLiteArray<MyData>()
        
        XCTAssertEqual(array.count, 0)
    }
    
    func testArrayMetadata() throws {
        
        let array = try SQLiteArray<MyData>()
        let metadata = array.metadata

        XCTAssertEqual(array.sqlForCreateTable(), #"CREATE TABLE "MyData" ("id" INTEGER NOT NULL, "flags" REAL, "name" TEXT NOT NULL)"#)

        XCTAssertEqual(array.tableName, "\"MyData\"")
        XCTAssertEqual(metadata.map(\.name), ["id", "flags", "name"])
        XCTAssertEqual(metadata.map(\.datatype), [.integer, .real, .text])
        XCTAssertEqual(metadata.map(\.nullable), [false, true, false])
        XCTAssertEqual(metadata.map(\.offset), [MemoryLayout<MyData>.offset(of: \MyData.id), MemoryLayout<MyData>.offset(of: \MyData.flags), MemoryLayout<MyData>.offset(of: \MyData.name)])
        XCTAssertEqual(metadata.map(\.size), [MemoryLayout<Int>.size, MemoryLayout<Double?>.size, MemoryLayout<String>.size])

        XCTAssertEqual(metadata[0].sql, "\"id\" INTEGER NOT NULL")
        XCTAssertEqual(metadata[1].sql, "\"flags\" REAL")
        XCTAssertEqual(metadata[2].sql, "\"name\" TEXT NOT NULL")
    }
    
    func testDataType() throws {
        
        XCTAssertEqual(SQLite3.DataType.integer.description, "INTEGER")
        XCTAssertEqual(SQLite3.DataType.real.description, "REAL")
        XCTAssertEqual(SQLite3.DataType.text.description, "TEXT")
        XCTAssertEqual(SQLite3.DataType.null.description, "NULL")
    }
}
