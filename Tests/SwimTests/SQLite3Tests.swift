//
//  SQLite3Tests.swift
//  SwimTests
//
//  Created by Tomohiro Kumagai on 2020/11/11.
//

import XCTest
@testable import Swim
import SQLite3

/**
 FIXME: WORKAROUND
 Now SwiftPM seems to copy resources for unit test to bundle.
 In addition, even if execute `swift test`, the resources cannot be found in `Bundle.module`.
 To find the resources, specify the resource's path directly. (not in bundle.)
 */
//        let path = Bundle(for: Self.self).path(forResource: "EZ-NET", ofType: "sqlite3")!
//        let path = Bundle.module.path(forResource: "EZ-NET", ofType: "sqlite3")!
let databasePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("Resources/EZ-NET.sqlite3").absoluteString

private struct MyData : Equatable, SQLite3Translateable {
    
    var id: Int
    var flags: Double?
    var name: String
    var option: SQLite3.Value
}

class SQLite3Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAttachDatabase() throws {
        
        let sqlite = try SQLite3(path: databasePath, options: .readonly)
        
        guard let main = try sqlite.execute(sql: "SELECT count(*) FROM main.Updates") else {
            
            XCTFail("Expect some data exists.")
            return
        }

        XCTAssertEqual(main.row.first!.integerValue, 1852)

        XCTAssertThrowsError(try sqlite.execute(sql: "SELECT count(*) FROM sub.Updates"))
        XCTAssertNoThrow(try sqlite.attach(databasePath: databasePath, to: "sub"))
        XCTAssertNoThrow(try sqlite.execute(sql: "SELECT count(*) FROM sub.Updates"))

        guard let sub = try sqlite.execute(sql: "SELECT count(*) FROM sub.Updates") else {
            
            XCTFail("Expect some data exists.")
            return
        }

        XCTAssertEqual(sub.row.first!.integerValue, 1852)
    }
    
    func testRead() throws {
                
        let sqlite = try SQLite3(path: databasePath, options: .readonly)
        
        XCTAssertThrowsError(try sqlite.execute(sql: "SELECT FROM Updates"))
        XCTAssertThrowsError(try sqlite.execute(sql: "SELECT * FROM Dummy"))

        let statement = try sqlite.prepareStatement(with: "SELECT * FROM Updates WHERE UpdateID BETWEEN @idMin AND @idMax ORDER BY UpdateID") { statement in
            
            try statement.parameter("@idMin").bind(1178)
            try statement.parameter("@idMax").bind(1180)
        }
        
        XCTAssertEqual(statement.columnCount, 6)
        XCTAssertEqual(statement.columnNames, ["UpdateID", "State", "Caption", "Description", "URI", "DateTime"])

        XCTAssertTrue(try statement.step())

        XCTAssertEqual(statement.row[0].actualType, .integer)
        XCTAssertEqual(statement.row[1].actualType, .text)
        XCTAssertEqual(statement.row[2].actualType, .text)
        XCTAssertEqual(statement.row[3].actualType, .text)
        XCTAssertEqual(statement.row[4].actualType, .text)
        XCTAssertEqual(statement.row[5].actualType, .text)

        XCTAssertEqual(statement.row[0].integerValue, 1178)
        XCTAssertEqual(statement.row[2].textValue, "UISlider の値を操作する。")
        XCTAssertEqual(statement.row[4].textValue, "/article/8A/3GTRi2tH/SYJ1jMo5TVWw/")
        XCTAssertEqual(statement.row.columns.UpdateID.integerValue, 1178)
        XCTAssertEqual(statement.row.columns.Caption.textValue, "UISlider の値を操作する。")
        XCTAssertEqual(statement.row.columns.URI.textValue, "/article/8A/3GTRi2tH/SYJ1jMo5TVWw/")

        XCTAssertTrue(try statement.step())
        
        XCTAssertEqual(statement.row[0].integerValue, 1179)
        XCTAssertEqual(statement.row[2].textValue, "UISwitch の値を操作する。")
        XCTAssertEqual(statement.row[4].textValue, "/article/51/_SXHqIpL/zaKazZyqkneE/")
        XCTAssertEqual(statement.row["UpdateID"].integerValue, 1179)
        XCTAssertEqual(statement.row["Caption"].textValue, "UISwitch の値を操作する。")
        XCTAssertEqual(statement.row["URI"].textValue, "/article/51/_SXHqIpL/zaKazZyqkneE/")

        XCTAssertTrue(try statement.step())

        XCTAssertEqual(statement.row[0].integerValue, 1180)
        XCTAssertEqual(statement.row[2].textValue, "UIScrollView をスクロールさせる。")
        XCTAssertEqual(statement.row[4].textValue, "/article/51/KyIcnlBE/PadIz8Rd3cRa/")

        XCTAssertFalse(try statement.step())
        
        XCTAssertNoThrow(try statement.reset())
        
        XCTAssertTrue(try statement.step())

        XCTAssertEqual(statement.row[0].actualType, .integer)
        XCTAssertEqual(statement.row[1].actualType, .text)
        XCTAssertEqual(statement.row[2].actualType, .text)
        XCTAssertEqual(statement.row[3].actualType, .text)
        XCTAssertEqual(statement.row[4].actualType, .text)
        XCTAssertEqual(statement.row[5].actualType, .text)

        XCTAssertEqual(statement.row[0].integerValue, 1178)
        XCTAssertEqual(statement.row[2].textValue, "UISlider の値を操作する。")
        XCTAssertEqual(statement.row[4].textValue, "/article/8A/3GTRi2tH/SYJ1jMo5TVWw/")
        XCTAssertEqual(statement.row.columns.UpdateID.integerValue, 1178)
        XCTAssertEqual(statement.row.columns.Caption.textValue, "UISlider の値を操作する。")
        XCTAssertEqual(statement.row.columns.URI.textValue, "/article/8A/3GTRi2tH/SYJ1jMo5TVWw/")

        XCTAssertTrue(try statement.step())
        
        XCTAssertEqual(statement.row[0].integerValue, 1179)
        XCTAssertEqual(statement.row[2].textValue, "UISwitch の値を操作する。")
        XCTAssertEqual(statement.row[4].textValue, "/article/51/_SXHqIpL/zaKazZyqkneE/")
        XCTAssertEqual(statement.row["UpdateID"].integerValue, 1179)
        XCTAssertEqual(statement.row["Caption"].textValue, "UISwitch の値を操作する。")
        XCTAssertEqual(statement.row["URI"].textValue, "/article/51/_SXHqIpL/zaKazZyqkneE/")

        XCTAssertTrue(try statement.step())

        XCTAssertEqual(statement.row[0].integerValue, 1180)
        XCTAssertEqual(statement.row[2].textValue, "UIScrollView をスクロールさせる。")
        XCTAssertEqual(statement.row[4].textValue, "/article/51/KyIcnlBE/PadIz8Rd3cRa/")
    }
    
    func testKeepCurrentStepIteration() throws {

        let sqlite = try SQLite3(path: databasePath, options: .readonly)
        
        XCTAssertThrowsError(try sqlite.execute(sql: "SELECT FROM Updates"))
        XCTAssertThrowsError(try sqlite.execute(sql: "SELECT * FROM Dummy"))

        let statement = try sqlite.prepareStatement(with: "SELECT * FROM Updates WHERE UpdateID BETWEEN @idMin AND @idMax ORDER BY UpdateID") { statement in
            
            try statement.parameter("@idMin").bind(1178)
            try statement.parameter("@idMax").bind(1180)
        }
        
        XCTAssertNoThrow(try statement.reset())
        XCTAssertTrue(try statement.step())
        
        XCTAssertEqual(statement.makeIterator(keepCurrentStep: true).map(\.row!.columns.UpdateID.integerValue), [1179, 1180])
        
        XCTAssertNoThrow(try statement.reset())
        XCTAssertTrue(try statement.step())
        
        XCTAssertEqual(statement.makeIterator(keepCurrentStep: false).map(\.row!.columns.UpdateID.integerValue), [1178, 1179, 1180])
    }
    
    func testWrite() throws {
        
        let sqlite = try SQLite3(store: .onMemory, options: .readwrite)
        
        XCTAssertEqual(sqlite.recentChanges, 0)
        
        try sqlite.execute(sql: "CREATE TABLE sample(id INTEGER NOT NULL PRIMARY KEY, name TEXT, flag REAL DEFAULT 1.5, dummy NULL)")
        XCTAssertEqual(sqlite.recentChanges, 0)

        let info = try sqlite.execute(sql: "PRAGMA table_info('sample')")!
        XCTAssertEqual(sqlite.recentChanges, 0)

        XCTAssertEqual(info.columnCount, 6)
        
        XCTAssertEqual(info.row.columns.cid.integerValue, 0)
        XCTAssertEqual(info.row.columns.name.textValue, "id")
        XCTAssertEqual(info.row.columns.type.textValue, "INTEGER")
        XCTAssertEqual(info.row.columns.notnull.integerValue, 1)
        XCTAssertTrue(info.row.columns.dflt_value.isNull)
        XCTAssertEqual(info.row.columns.pk.integerValue, 1)

        XCTAssertTrue(try info.step())
        
        XCTAssertEqual(info.row.columns.cid.integerValue, 1)
        XCTAssertEqual(info.row.columns.name.textValue, "name")
        XCTAssertEqual(info.row.columns.type.textValue, "TEXT")
        XCTAssertEqual(info.row.columns.notnull.integerValue, 0)
        XCTAssertTrue(info.row.columns.dflt_value.isNull)
        XCTAssertEqual(info.row.columns.pk.integerValue, 0)

        XCTAssertTrue(try info.step())
        
        XCTAssertEqual(info.row.columns.cid.integerValue, 2)
        XCTAssertEqual(info.row.columns.name.textValue, "flag")
        XCTAssertEqual(info.row.columns.type.textValue, "REAL")
        XCTAssertEqual(info.row.columns.notnull.integerValue, 0)
        XCTAssertEqual(info.row.columns.dflt_value.textValue, "1.5")
        XCTAssertEqual(info.row.columns.pk.integerValue, 0)

        XCTAssertTrue(try info.step())

        XCTAssertEqual(info.row.columns.cid.integerValue, 3)
        XCTAssertEqual(info.row.columns.name.textValue, "dummy")
        XCTAssertEqual(info.row.columns.type.textValue, "")
        XCTAssertEqual(info.row.columns.notnull.integerValue, 0)
        XCTAssertTrue(info.row.columns.dflt_value.isNull)
        XCTAssertEqual(info.row.columns.pk.integerValue, 0)

        XCTAssertFalse(try info.step())
        
        let st1 = try sqlite.execute(sql: "SELECT * FROM sample")
        XCTAssertEqual(sqlite.recentChanges, 0)

        XCTAssertNil(st1)
        
        try sqlite.execute(sql: "INSERT INTO sample (id, name, flag) VALUES (10, 'EZ-NET', 1.5), (22, 'ORIENT', NULL)")
        XCTAssertEqual(sqlite.recentChanges, 2)

        guard let st2 = try sqlite.execute(sql: "SELECT * FROM sample") else {
            
            XCTFail("Expect some data exists.")
            return
        }

        XCTAssertEqual(sqlite.recentChanges, 2)

        XCTAssertEqual(st2.row.columns.id.integerValue, 10)
        XCTAssertEqual(st2.row.columns.name.textValue, "EZ-NET")
        XCTAssertEqual(st2.row.columns.flag.realValue, 1.5)

        XCTAssertTrue(try st2.step())

        XCTAssertEqual(st2.row.columns.id.integerValue, 22)
        XCTAssertEqual(st2.row.columns.name.textValue, "ORIENT")
        XCTAssertNil(st2.row.columns.flag.realValue)

        XCTAssertFalse(try st2.step())

        let st3 = try sqlite.prepareStatement(with: "SELECT * FROM sample ORDER BY id DESC")

        let values = st3.map {
            
            $0.row.columns.name.textValue
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
        
        array.insert(MyData(id: 5, flags: 1.5, name: "AAA", option: SQLite3.Value(10)))
        XCTAssertEqual(array.count, 1)

        array.insert(MyData(id: 12, flags: nil, name: "BBB", option: SQLite3.Value(10.5)))
        XCTAssertEqual(array.count, 2)
    }
    
    func testTranslate() throws {
        
        let translator = try SQLite3.Translator<MyData>()
        let metadata = translator.metadata

        let createSQL = translator.makeCreateTableSQL()
        XCTAssertEqual(createSQL, #"CREATE TABLE "MyData" ("id" INTEGER NOT NULL, "flags" REAL, "name" TEXT NOT NULL, "option" NOT NULL)"#)

        XCTAssertEqual(translator.tableName, "\"MyData\"")
        XCTAssertEqual(metadata.map(\.name), ["id", "flags", "name", "option"])
        XCTAssertEqual(metadata.map(\.datatype), [.integer, .real, .text, .variant])
        XCTAssertEqual(metadata.map(\.nullable), [false, true, false, false])
        XCTAssertEqual(metadata.map(\.offset), [MemoryLayout<MyData>.offset(of: \MyData.id), MemoryLayout<MyData>.offset(of: \MyData.flags), MemoryLayout<MyData>.offset(of: \MyData.name), MemoryLayout<MyData>.offset(of: \MyData.option)])
        XCTAssertEqual(metadata.map(\.size), [MemoryLayout<Int>.size, MemoryLayout<Double?>.size, MemoryLayout<String>.size, MemoryLayout<SQLite3.Value>.size])

        XCTAssertEqual(metadata[0].sql, "\"id\" INTEGER NOT NULL")
        XCTAssertEqual(metadata[1].sql, "\"flags\" REAL")
        XCTAssertEqual(metadata[2].sql, "\"name\" TEXT NOT NULL")
        
        let data1 = MyData(id: 5, flags: 1.23, name: "D1", option: .init(10))
        let data2 = MyData(id: 12, flags: nil, name: "D2", option: .init(10.5))
        
        let insertSQL1 = translator.makeInsertSQL(for: data1)
        let insertSQL2 = translator.makeInsertSQL(for: data2)

        XCTAssertEqual(insertSQL1, #"INSERT INTO "MyData" ("id", "flags", "name", "option") VALUES (5, 1.23, 'D1', 10)"#)
        XCTAssertEqual(insertSQL2, #"INSERT INTO "MyData" ("id", "flags", "name", "option") VALUES (12, NULL, 'D2', 10.5)"#)
        
        
        let sqlite = try SQLite3(store: .onMemory, options: .readwrite)
        
        XCTAssertNoThrow(try sqlite.execute(sql: createSQL))
        XCTAssertNoThrow(try sqlite.execute(sql: insertSQL1))
        XCTAssertNoThrow(try sqlite.execute(sql: insertSQL2))
        
        let statement = try sqlite.prepareStatement(with: "SELECT * FROM \(translator.tableName)")

        let values = statement.map(translator.instantiate(from:))
        
        XCTAssertEqual(values[0], data1)
        XCTAssertEqual(values[1], data2)
    }
    
    func testColumnType() throws {
        
        let sqlite = try SQLite3.instantiateOnMemory()
        try sqlite.execute(sql: "CREATE TABLE sample(id INTEGER NOT NULL PRIMARY KEY, name TEXT, flag REAL DEFAULT 1.5, dummy NULL)")
        try sqlite.execute(sql: "INSERT INTO sample (id, name, flag, dummy) VALUES (22, 'ORIENT', NULL, 'TEXT')")

        let statement = try sqlite.execute(sql: "SELECT * FROM sample")!
        
        
        XCTAssertEqual(statement.row[0].declaredType, .integer)
        XCTAssertEqual(statement.row[0].actualType, .integer)
        XCTAssertEqual(statement.row[2].declaredType, .real)
        XCTAssertEqual(statement.row[2].actualType, .null)
//        XCTAssertEqual(statement.row[3].declaredType, .real) // Undefined type is not supported yet.
        XCTAssertEqual(statement.row[3].actualType, .text)
    }
    
    func testArrayMetadata() throws {
        
        let array = try SQLiteArray<MyData>()

    }
    
    func testDataType() throws {
        
        XCTAssertEqual(SQLite3.DefineDataType.integer.description, "INTEGER")
        XCTAssertEqual(SQLite3.DefineDataType.real.description, "REAL")
        XCTAssertEqual(SQLite3.DefineDataType.text.description, "TEXT")
        XCTAssertEqual(SQLite3.DefineDataType.variant.description, "")

        XCTAssertEqual(SQLite3.ActualDataType.integer.description, "INTEGER")
        XCTAssertEqual(SQLite3.ActualDataType.real.description, "REAL")
        XCTAssertEqual(SQLite3.ActualDataType.text.description, "TEXT")
        XCTAssertEqual(SQLite3.ActualDataType.null.description, "NULL")
    }
    
    func testValue() throws {
        
        let v1a = SQLite3.Value(10)
        let v1b = SQLite3.Value(nil as Int?)
        let v2a = SQLite3.Value(10 as Double)
        let v2b = SQLite3.Value(nil as Double?)
        let v3a = SQLite3.Value("TEXT")
        let v3b = SQLite3.Value(nil as String?)
        let v4a = SQLite3.Value.unspecified(10)
        let v4b = SQLite3.Value.unspecified(nil)
        
        XCTAssertEqual(v1a.description, "10")
        XCTAssertEqual(v1b.description, "NULL")
        XCTAssertEqual(v2a.description, "10.0")
        XCTAssertEqual(v2b.description, "NULL")
        XCTAssertEqual(v3a.description, "'TEXT'")
        XCTAssertEqual(v3b.description, "NULL")
        XCTAssertEqual(v4a.description, "10")
        XCTAssertEqual(v4b.description, "NULL")
        
        XCTAssertFalse(v1a.isNull)
        XCTAssertTrue(v1b.isNull)
        XCTAssertFalse(v2a.isNull)
        XCTAssertTrue(v2b.isNull)
        XCTAssertFalse(v3a.isNull)
        XCTAssertTrue(v3b.isNull)
        XCTAssertFalse(v4a.isNull)
        XCTAssertTrue(v4b.isNull)
        
        XCTAssertEqual(v1a.declaredType, .variant)
        XCTAssertEqual(v1b.declaredType, .variant)
        XCTAssertEqual(v2a.declaredType, .variant)
        XCTAssertEqual(v2b.declaredType, .variant)
        XCTAssertEqual(v3a.declaredType, .variant)
        XCTAssertEqual(v3b.declaredType, .variant)
        XCTAssertEqual(v4a.declaredType, .variant)
        XCTAssertEqual(v4b.declaredType, .variant)
        
        XCTAssertEqual(v1a.actualType, .integer)
        XCTAssertEqual(v1b.actualType, .null)
        XCTAssertEqual(v2a.actualType, .real)
        XCTAssertEqual(v2b.actualType, .null)
        XCTAssertEqual(v3a.actualType, .text)
        XCTAssertEqual(v3b.actualType, .null)
        XCTAssertEqual(v4a.actualType, .integer)
        XCTAssertEqual(v4b.actualType, .null)
        
        XCTAssertEqual(v1a.self, v1a)
        XCTAssertEqual(v1b.self, v1b)
        XCTAssertEqual(v2a.self, v2a)
        XCTAssertEqual(v2b.self, v2b)
        XCTAssertEqual(v3a.self, v3a)
        XCTAssertEqual(v3b.self, v3b)
        XCTAssertEqual(v4a.self, v4a)
        XCTAssertEqual(v4b.self, v4b)

        XCTAssertEqual(v1a, v4a)
        XCTAssertNotEqual(v1a, v2a)
    }
    
    func testCondition() throws {
        
        let condition1 = SQLite3.Condition.equal("key", .integer(10))
        let condition2 = SQLite3.Condition.notEqual("key", .text("ABC"))
        let condition3 = SQLite3.Condition.lessThan("key", .integer(10))
        let condition4 = SQLite3.Condition.lessOrEqual("key", .integer(10))
        let condition5 = SQLite3.Condition.greaterThan("key", .integer(12))
        let condition6 = SQLite3.Condition.greaterOrEqual("key", .integer(12))
        let condition7 = SQLite3.Condition.between("key", .real(5), .real(100))

        XCTAssertEqual(condition1.sql, #""key" = 10"#)
        XCTAssertEqual(condition2.sql, #""key" != 'ABC'"#)
        XCTAssertEqual(condition3.sql, #""key" < 10"#)
        XCTAssertEqual(condition4.sql, #""key" <= 10"#)
        XCTAssertEqual(condition5.sql, #""key" > 12"#)
        XCTAssertEqual(condition6.sql, #""key" >= 12"#)
        XCTAssertEqual(condition7.sql, #""key" BETWEEN 5.0 AND 100.0"#)
    }
}
