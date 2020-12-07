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

private struct MyData : Equatable {
    
    var id: Int
    var flags: Double?
    var name: String
    var option: SQLite3.Value
}

extension MyData : SQLite3Translateable {
    
    static var sqlite3DefaultValue = MyData(id: 0, flags: nil, name: "", option: .null)

    @SQLite3.ColumnsDeclaration
    static var sqlite3Columns: [Column] {
        
        Column("id", keyPath: \.id)
        Column("flags", keyPath: \.flags)
        Column("name", keyPath: \.name)
        Column("option", keyPath: \.option)
    }
}

private struct MyData2 : Equatable {
    
    var id: Int
    var flags: Double?
    var name: String
    var option: SQLite3.Value
}

extension MyData2 : SQLite3Translateable {
    
    static var sqlite3DefaultValue = MyData2(id: 0, flags: nil, name: "", option: .null)
    
    @SQLite3.ColumnsDeclaration
    static var sqlite3Columns: [Column] {
        
        Column("id", keyPath: \.id, primaryKey: true)
        Column("flags", keyPath: \.flags)
        Column("name", keyPath: \.name)
        Column("option", keyPath: \.option)
    }
    
    @SQLite3.IndexDeclaration
    static var sqlite3Indexes: [Index] {
        
        Index("id", fieldNames: ["id"])
    }
}

private struct MyData3 : Equatable {
    
    var id: Int
    var flags: Double?
    var name: String
    var option: SQLite3.Value
}

extension MyData3 : SQLite3Translateable {
    
    static var sqlite3DefaultValue = MyData3(id: 0, flags: nil, name: "", option: .null)
    
    @SQLite3.ColumnsDeclaration
    static var sqlite3Columns: [Column] {
        
        Column("id", keyPath: \.id, primaryKey: true)
        Column("flags", keyPath: \.flags)
        Column("name", keyPath: \.name, primaryKey: true)
        Column("option", keyPath: \.option)
    }
    
    @SQLite3.IndexDeclaration
    static var sqlite3Indexes: [Index] {
        
        Index("id", fieldNames: ["id"], unique: true)
        Index("option", fieldNames: ["option", "flags"])
    }
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
        
        XCTAssertEqual(SQLite3.quotedText("TEXT"), "'TEXT'")
        XCTAssertEqual(SQLite3.quotedFieldName("FIELD"), "\"FIELD\"")
        XCTAssertEqual(SQLite3.quotedText("TE'XT"), "'TE''XT'")
        XCTAssertEqual(SQLite3.quotedFieldName("FI\"ELD"), "\"FI\"\"ELD\"")
    }
    
    func testArray1() throws {
        
        var array = try SQLiteSequence<MyData>()
        
        XCTAssertEqual(array.count, 0)
        
        array.append(MyData(id: 5, flags: 1.5, name: "AAA", option: SQLite3.Value(10)))
        XCTAssertEqual(array.count, 1)
        
        array.append(MyData(id: 12, flags: nil, name: "BBB", option: SQLite3.Value(10.5)))
        XCTAssertEqual(array.count, 2)
    }
    
    func testArray2() throws {
        
        var array = try SQLiteSequence<MyData2>()
        
        XCTAssertEqual(array.count, 0)
        
        array.append(MyData2(id: 5, flags: 1.5, name: "AAA", option: SQLite3.Value(10)))
        XCTAssertEqual(array.count, 1)
        
        array.append(MyData2(id: 12, flags: nil, name: "BBB", option: SQLite3.Value(10.5)))
        XCTAssertEqual(array.count, 2)
    }
    
    func testArray3() throws {
        
        var array = try SQLiteSequence<MyData3>()
        
        XCTAssertEqual(array.count, 0)
        
        array.append(MyData3(id: 5, flags: 1.5, name: "AAA", option: SQLite3.Value(10)))
        XCTAssertEqual(array.count, 1)
        
        array.append(MyData3(id: 12, flags: nil, name: "BBB", option: SQLite3.Value(10.5)))
        XCTAssertEqual(array.count, 2)
    }
    
    func testSQL() throws {
    
        let translatorA = SQLite3.Translator<MyData>()
        let translatorB = SQLite3.Translator<MyData2>()
        let translatorC = SQLite3.Translator<MyData3>()

        let sql1a = translatorA.makeCreateTableSQL()
        let sql2a = translatorA.makeDropTableSQL()
        let sql3a = translatorA.makeCreateIndexSQLs()
        let sql4a = translatorA.makeBeginTransactionSQL()
        let sql5a = translatorA.makeCommitTransactionSQL()
        let sql6a = translatorA.makeRollbackTransactionSQL()
        
        let sql1b = translatorB.makeCreateTableSQL()
        let sql2b = translatorB.makeDropTableSQL()
        let sql3b = translatorB.makeCreateIndexSQLs()
        let sql4b = translatorB.makeBeginTransactionSQL()
        let sql5b = translatorB.makeCommitTransactionSQL()
        let sql6b = translatorB.makeRollbackTransactionSQL()
        
        let sql1c = translatorC.makeCreateTableSQL()
        let sql2c = translatorC.makeDropTableSQL()
        let sql3c = translatorC.makeCreateIndexSQLs()
        let sql4c = translatorC.makeBeginTransactionSQL()
        let sql5c = translatorC.makeCommitTransactionSQL()
        let sql6c = translatorC.makeRollbackTransactionSQL()
        
        XCTAssertEqual(sql1a.description, #"CREATE TABLE "MyData" ("id" INTEGER NOT NULL, "flags" REAL, "name" TEXT NOT NULL, "option")"#)
        XCTAssertEqual(sql2a.description, #"DROP TABLE "MyData""#)
        XCTAssertEqual(sql3a.map(\.description), [])
        XCTAssertEqual(sql4a.description, #"BEGIN TRANSACTION"#)
        XCTAssertEqual(sql5a.description, #"COMMIT TRANSACTION"#)
        XCTAssertEqual(sql6a.description, #"ROLLBACK TRANSACTION"#)
        
        XCTAssertEqual(sql1b.description, #"CREATE TABLE "MyData2" ("id" INTEGER PRIMARY KEY NOT NULL, "flags" REAL, "name" TEXT NOT NULL, "option")"#)
        XCTAssertEqual(sql2b.description, #"DROP TABLE "MyData2""#)
        XCTAssertEqual(sql3b.map(\.description), [#"CREATE INDEX "Index_MyData2_id" ON "MyData2" ("id")"#])
        XCTAssertEqual(sql4b.description, #"BEGIN TRANSACTION"#)
        XCTAssertEqual(sql5b.description, #"COMMIT TRANSACTION"#)
        XCTAssertEqual(sql6b.description, #"ROLLBACK TRANSACTION"#)
        
        XCTAssertEqual(sql1c.description, #"CREATE TABLE "MyData3" ("id" INTEGER NOT NULL, "flags" REAL, "name" TEXT NOT NULL, "option", PRIMARY KEY ("id", "name"))"#)
        XCTAssertEqual(sql2c.description, #"DROP TABLE "MyData3""#)
        XCTAssertEqual(sql3c.map(\.description), [#"CREATE UNIQUE INDEX "Index_MyData3_id" ON "MyData3" ("id")"#, #"CREATE INDEX "Index_MyData3_option" ON "MyData3" ("option", "flags")"#])
        XCTAssertEqual(sql4c.description, #"BEGIN TRANSACTION"#)
        XCTAssertEqual(sql5c.description, #"COMMIT TRANSACTION"#)
        XCTAssertEqual(sql6c.description, #"ROLLBACK TRANSACTION"#)
    }
    
    func testTranslate() throws {
        
        let translator = SQLite3.Translator<MyData>()
        let datatype = MyData.self

        let metadata = MyData.sqlite3Columns
        
        let createSQL = SQLite3.SQL.createTable(datatype)
        XCTAssertEqual(createSQL.description, #"CREATE TABLE "MyData" ("id" INTEGER NOT NULL, "flags" REAL, "name" TEXT NOT NULL, "option")"#)
        
        XCTAssertEqual(datatype.tableName, "MyData")
        XCTAssertEqual(metadata.map(\.field.name), ["id", "flags", "name", "option"])
        XCTAssertEqual(metadata.map(\.datatype), [.integer, .real, .text, .variant])
        XCTAssertEqual(metadata.map(\.nullable), [false, true, false, true])
        XCTAssertEqual(metadata.map(\.offset), [MemoryLayout<MyData>.offset(of: \MyData.id), MemoryLayout<MyData>.offset(of: \MyData.flags), MemoryLayout<MyData>.offset(of: \MyData.name), MemoryLayout<MyData>.offset(of: \MyData.option)])
        
        XCTAssertEqual(metadata[0].declareSQL(markAsPrimaryKey: true), "\"id\" INTEGER PRIMARY KEY NOT NULL")
        XCTAssertEqual(metadata[1].declareSQL(markAsPrimaryKey: false), "\"flags\" REAL")
        XCTAssertEqual(metadata[2].declareSQL(markAsPrimaryKey: false), "\"name\" TEXT NOT NULL")
        XCTAssertEqual(metadata[3].declareSQL(markAsPrimaryKey: false), "\"option\"", "Currenly, SQLite3.Value don't support nonnull VARIANT.")
        
        let data1 = MyData(id: 5, flags: 1.23, name: "D1", option: .init(10))
        let data2 = MyData(id: 12, flags: nil, name: "D2", option: .init(10.5))
        
        let insertSQL1 = SQLite3.SQL.insert(data1)
        let insertSQL2 = SQLite3.SQL.insert(data2)
        
        XCTAssertEqual(insertSQL1.description, #"INSERT INTO "MyData" ("id", "flags", "name", "option") VALUES (5, 1.23, 'D1', 10)"#)
        XCTAssertEqual(insertSQL2.description, #"INSERT INTO "MyData" ("id", "flags", "name", "option") VALUES (12, NULL, 'D2', 10.5)"#)
        
        
        let sqlite = try SQLite3(store: .onMemory, options: .readwrite)
        
        XCTAssertNoThrow(try sqlite.execute(sql: createSQL.description))
        XCTAssertNoThrow(try sqlite.execute(sql: insertSQL1.description))
        XCTAssertNoThrow(try sqlite.execute(sql: insertSQL2.description))
        
        let selectSQL1 = SQLite3.SQL.select(from: datatype)
        let selectSQL2 = SQLite3.SQL.select(from: datatype, where: \MyData.id == (3...5))
        let selectSQL3 = SQLite3.SQL.select(from: datatype, where: \MyData.name == "TEST")
        let selectSQL4 = SQLite3.SQL.select(from: datatype, where: \MyData.id < 3)
        let selectSQL5 = SQLite3.SQL.select(from: datatype, where: \MyData.id <= 3)
        let selectSQL6 = SQLite3.SQL.select(from: datatype, where: \MyData.id > 3)
        let selectSQL7 = SQLite3.SQL.select(from: datatype, where: \MyData.id >= 3)
        let selectSQL8 = SQLite3.SQL.select(from: datatype, where: \MyData.id == (3...5))
        let selectSQL9 = SQLite3.SQL.select(from: datatype, where: SQLite3.Conditions.notBetween(\MyData.id, 3, 5).and(\MyData.name == "TEST"))
        let selectSQL10 = SQLite3.SQL.select(from: datatype, where:
                                                SQLite3.Conditions.satisfyAll {
                                                    \MyData.id != (3...5)
                                                    \MyData.name == "TEST"
                                                }
                                                .or(\MyData.option < 10))
        
        let selectSQL11 = SQLite3.SQL.select(from: datatype, where: .notBetween(\MyData.id, 3, 5)).and((\MyData.name == "TEST").or(\MyData.option < 10))
        let selectSQL12 = SQLite3.SQL.select(from: datatype, where:
                                                .satisfyAll {
                                                    \MyData.id != (3...5)
                                                    \MyData.name == "TEST"
                                                    \MyData.option < 10
                                                })
        let selectSQL13 = SQLite3.SQL.select(SQLite3.Field("*", function: "COUNT"), from: MyData.self)
        let selectSQL14 = SQLite3.SQL.select(from: datatype, where: .isNull(\MyData.option))
        let selectSQL15 = SQLite3.SQL.select(from: datatype, where: .isNotNull(\MyData.option))
        let selectSQL16 = SQLite3.SQL.select(from: datatype, where: \MyData.name == ["A", "B", "C"])
        let selectSQL17 = SQLite3.SQL.select(from: datatype, where: \MyData.id != [3, 8, 10])
        let selectSQL18 = SQLite3.SQL.select(from: datatype, where: .like(\MyData.name, "%TEST%"))
        let selectSQL19 = SQLite3.SQL.select(from: datatype, where: .notLike(\MyData.name, "%TEST%"))
        let selectSQL20 = SQLite3.SQL.select(from: datatype, where: \MyData.name =~ ".*")
        let selectSQL21 = SQLite3.SQL.select(from: datatype, where: .regularExpression(\MyData.name, ".*", caseSensitive: true))
        
        XCTAssertEqual(selectSQL1.description, #"SELECT * FROM "MyData""#)
        XCTAssertEqual(selectSQL2.description, #"SELECT * FROM "MyData" WHERE ("id" BETWEEN 3 AND 5)"#)
        XCTAssertEqual(selectSQL3.description, #"SELECT * FROM "MyData" WHERE ("name" = 'TEST')"#)
        XCTAssertEqual(selectSQL4.description, #"SELECT * FROM "MyData" WHERE ("id" < 3)"#)
        XCTAssertEqual(selectSQL5.description, #"SELECT * FROM "MyData" WHERE ("id" <= 3)"#)
        XCTAssertEqual(selectSQL6.description, #"SELECT * FROM "MyData" WHERE ("id" > 3)"#)
        XCTAssertEqual(selectSQL7.description, #"SELECT * FROM "MyData" WHERE ("id" >= 3)"#)
        XCTAssertEqual(selectSQL8.description, #"SELECT * FROM "MyData" WHERE ("id" BETWEEN 3 AND 5)"#)
        XCTAssertEqual(selectSQL9.description, #"SELECT * FROM "MyData" WHERE (("id" NOT BETWEEN 3 AND 5) AND ("name" = 'TEST'))"#)
        XCTAssertEqual(selectSQL10.description, #"SELECT * FROM "MyData" WHERE (("id" NOT BETWEEN 3 AND 5) AND ("name" = 'TEST') OR ("option" < 10))"#)
        XCTAssertEqual(selectSQL11.description, #"SELECT * FROM "MyData" WHERE (("id" NOT BETWEEN 3 AND 5) AND (("name" = 'TEST') OR ("option" < 10)))"#)
        XCTAssertEqual(selectSQL12.description, #"SELECT * FROM "MyData" WHERE (("id" NOT BETWEEN 3 AND 5) AND ("name" = 'TEST') AND ("option" < 10))"#)
        XCTAssertEqual(selectSQL13.description, #"SELECT COUNT(*) FROM "MyData""#)
        XCTAssertEqual(selectSQL14.description, #"SELECT * FROM "MyData" WHERE ("option" IS NULL)"#)
        XCTAssertEqual(selectSQL15.description, #"SELECT * FROM "MyData" WHERE ("option" IS NOT NULL)"#)
        XCTAssertEqual(selectSQL16.description, #"SELECT * FROM "MyData" WHERE ("name" IN ('A', 'B', 'C'))"#)
        XCTAssertEqual(selectSQL17.description, #"SELECT * FROM "MyData" WHERE ("id" NOT IN (3, 8, 10))"#)
        XCTAssertEqual(selectSQL18.description, #"SELECT * FROM "MyData" WHERE ("name" LIKE '%TEST%')"#)
        XCTAssertEqual(selectSQL19.description, #"SELECT * FROM "MyData" WHERE ("name" NOT LIKE '%TEST%')"#)
        XCTAssertEqual(selectSQL20.description, #"SELECT * FROM "MyData" WHERE ("name" REGEXP '.*')"#)
        XCTAssertEqual(selectSQL21.description, #"SELECT * FROM "MyData" WHERE ("name" REGEXP BINARY '.*')"#)

        let selectSQL1t = translator.makeSelectSQL()
        let selectSQL2t = translator.makeSelectSQL(where: \MyData.id == (3...5))
        let selectSQL3t = translator.makeSelectSQL(where: \MyData.name == "TEST")
        let selectSQL4t = translator.makeSelectSQL(where: \MyData.id < 3)
        let selectSQL5t = translator.makeSelectSQL(where: \MyData.id <= 3)
        let selectSQL6t = translator.makeSelectSQL(where: \MyData.id > 3)
        let selectSQL7t = translator.makeSelectSQL(where: \MyData.id >= 3)
        let selectSQL8t = translator.makeSelectSQL(where: \MyData.id == (3...5))

        XCTAssertEqual(selectSQL1.description, selectSQL1t.description)
        XCTAssertEqual(selectSQL2.description, selectSQL2t.description)
        XCTAssertEqual(selectSQL3.description, selectSQL3t.description)
        XCTAssertEqual(selectSQL4.description, selectSQL4t.description)
        XCTAssertEqual(selectSQL5.description, selectSQL5t.description)
        XCTAssertEqual(selectSQL6.description, selectSQL6t.description)
        XCTAssertEqual(selectSQL7.description, selectSQL7t.description)
        XCTAssertEqual(selectSQL8.description, selectSQL8t.description)

        let statement = try sqlite.prepareStatement(with: selectSQL1.description)
        
        let values = statement.map(translator.instantiate(from:))
        
        XCTAssertEqual(values[0], data1)
        XCTAssertEqual(values[1], data2)
    }
    
    func testTranslatePrimaryKey() throws {
        
        let translator1 = SQLite3.Translator(MyData.self)
        let translator2 = SQLite3.Translator(MyData2.self)
        let translator3 = SQLite3.Translator(MyData3.self)
        
        let sql1 = translator1.makeCreateTableSQL()
        let sql2 = translator2.makeCreateTableSQL()
        let sql3 = translator3.makeCreateTableSQL()

        XCTAssertEqual(sql1.description, #"CREATE TABLE "MyData" ("id" INTEGER NOT NULL, "flags" REAL, "name" TEXT NOT NULL, "option")"#)
        XCTAssertEqual(sql2.description, #"CREATE TABLE "MyData2" ("id" INTEGER PRIMARY KEY NOT NULL, "flags" REAL, "name" TEXT NOT NULL, "option")"#)
        XCTAssertEqual(sql3.description, #"CREATE TABLE "MyData3" ("id" INTEGER NOT NULL, "flags" REAL, "name" TEXT NOT NULL, "option", PRIMARY KEY ("id", "name"))"#)
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
        
        var array = try SQLiteSequence<MyData>()
        
        array.append(MyData(id: 5, flags: nil, name: "A", option: .null))
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
        XCTAssertNotEqual(v1b.self, v1b, "Either one is null.")
        XCTAssertEqual(v2a.self, v2a)
        XCTAssertNotEqual(v2b.self, v2b, "Either one is null.")
        XCTAssertEqual(v3a.self, v3a)
        XCTAssertNotEqual(v3b.self, v3b, "Either one is null.")
        XCTAssertEqual(v4a.self, v4a)
        XCTAssertNotEqual(v4b.self, v4b, "Either one is null.")

        XCTAssertFalse(v1b.self == v1b, "Both is null.")
        XCTAssertFalse(v2b.self == v2b, "Both is null.")
        XCTAssertFalse(v3b.self == v3b, "Both is null.")
        XCTAssertFalse(v4b.self == v4b, "Both is null.")
        XCTAssertTrue(v1b.self <=> v1b, "Both is null.")
        XCTAssertTrue(v2b.self <=> v2b, "Both is null.")
        XCTAssertTrue(v3b.self <=> v3b, "Both is null.")
        XCTAssertTrue(v4b.self <=> v4b, "Both is null.")

        XCTAssertEqual(v1a, v4a)
        XCTAssertEqual(v1a, v2a, "In SQLite3, it can compare between real and integer.")
    }
    
    func testCondition() throws {
        
        let condition1 = SQLite3.ConditionElement.equal(\MyData.id, .integer(10))
        let condition2 = SQLite3.ConditionElement.notEqual(\MyData.name, .text("ABC"))
        let condition3 = SQLite3.ConditionElement.lessThan(\MyData.flags, .integer(10))
        let condition4 = SQLite3.ConditionElement.lessOrEqual(\MyData.id, .integer(10))
        let condition5 = SQLite3.ConditionElement.greaterThan(\MyData.id, .integer(12))
        let condition6 = SQLite3.ConditionElement.greaterOrEqual(\MyData.id, .integer(12))
        let condition7 = SQLite3.ConditionElement.between(\MyData.flags, .real(5), .real(100))
        
        XCTAssertEqual(condition1.sql, #""id" = 10"#)
        XCTAssertEqual(condition2.sql, #""name" != 'ABC'"#)
        XCTAssertEqual(condition3.sql, #""flags" < 10"#)
        XCTAssertEqual(condition4.sql, #""id" <= 10"#)
        XCTAssertEqual(condition5.sql, #""id" > 12"#)
        XCTAssertEqual(condition6.sql, #""id" >= 12"#)
        XCTAssertEqual(condition7.sql, #""flags" BETWEEN 5.0 AND 100.0"#)
    }
}
