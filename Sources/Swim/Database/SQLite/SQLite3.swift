//
//  SQLite3.swift
//  BitFlyerPriceHistoryImporter
//
//  Created by Tomohiro Kumagai on 2018/02/28.
//

import SQLite3

/// [Swim] A SQLite database instance.
public final class SQLite3 {
    
    /// [Swim] The store of this database.
	public internal(set) var store: Store
    
    /// [Swim] The internal pointer to the database which is managed by this instance.
    internal private(set) var pDB: OpaquePointer
    
    /// [Swim] Create a new SQLite instance with given store.
    /// - Parameters:
    ///   - store: The store to generate this database.
    ///   - options: The options to specified the open mode.
    /// - Throws: SQLite3.ResultCode when a database could not open.
    public init(store: Store, options: OpenOption) throws {
		
        var pDB: OpaquePointer?

        let code = sqlite3_open_v2(store.filename, &pDB, options.rawValue, nil)
        let resultCode = ResultCode(code)
		
        guard resultCode.isOK else {
            
            throw resultCode
        }
        
		self.store = store
		self.pDB = pDB!
	}
	
	deinit {
		
        try! ResultCode(sqlite3_close_v2(pDB)).throwIfError()
	}
    
    /// [Swim] Make a new statement with `sql` sentence; This method used to execute `SELECT` statement.
    ///
    /// - Parameters:
    ///   - sql: The SQL sentence of this statement.
    ///   - prepare: Evaluate to prepare this statement before executing `step` method.
    /// - Throws: SQLite3.ResultCode
    /// - Returns: Generated statement.
	public func prepareStatement(with sql: String, prepare: ((Statement) throws -> Void)? = nil) throws -> Statement {
		
		let statement = try Statement(db: self, sql: sql)
		
		try prepare?(statement)
		
		return statement
	}
        
    /// [Swim] Number of recent changes by executing `INSERT`, `UPDATE` or `DELETE` statement.
    public var recentChanges: Int {
        
        guard let statement = try? execute(sql: "SELECT changes()") else {
            
            return 0
        }
        
        return statement.row.first!.integerValue!
    }
    
    /// [Swim] Attach database
    /// - Parameters:
    ///   - databasePath: The path of a database to attach.
    ///   - name: The name of the database that is specified by `databasePath`.
    /// - Throws: SQLite3.ResultCode
    public func attach(databasePath: String, to name: String) throws {
        
        let path = SQLite3.quotedText(databasePath)
        let name = SQLite3.quotedFieldName(name)
        
        try execute(sql: "ATTACH DATABASE \(path) AS \(name)")
    }
    
    /// [Swim] Detach database
    /// - Parameter name: The name of the database that will be detached.
    /// - Throws: SQLite3.ResultCode
    public func detach(database name: String) throws {
        
        let name = SQLite3.quotedFieldName(name)
        
        try execute(sql: "DETACH DATABASE \(name)")
    }
}

extension SQLite3 {
    
    public static func instantiateOnMemory() throws -> SQLite3 {
    
        return try SQLite3(store: .onMemory, options: .readwrite)
    }
    
    /// [Swim] Create a new SQLite instance with given `path`.
    ///
    /// - Parameters:
    ///   - path: The path to a SQLite database file.
    ///   - options: The options to specified the open mode.
    /// - Throws: SQLite3.ResultCode when a database could not open.
    public convenience init(path: String, options: OpenOption) throws {
        
        try self.init(store: Store.path(path), options: options)
    }

    /// [Swim] Make a new statement with `sql` sentence and execute `step` method; This method used to execute `INSERT`, `UPDATE` or `DELETE` statement.
    ///
    /// - Parameters:
    ///   - sql: The SQL sentence of this statement.
    ///   - prepare: Evaluate to prepare this statement before executing `step` method.
    /// - Throws: SQLite3.ResultCode
    /// - Returns: New executed statement if `step` method returns true, otherwise nil.
    @discardableResult
    public func execute(sql: String, prepare: ((Statement) throws -> Void)? = nil) throws -> Statement? {
        
        let statement = try prepareStatement(with: sql)
        
        try prepare?(statement)
        
        switch try statement.step() {
        
        case true:
            return statement
            
        case false:
            return nil
        }
    }
    
    /// [Swim] Return a boolean value whether the table named `name` is exists on current database.
    ///
    /// - Parameters:
    ///   - name: The table name to look for.
    /// - Returns: True iff specified table is exist, otherwise false.
    public func isTableExists(_ name: String) -> Bool {
        
        let statement = try! execute(sql: #"SELECT COUNT(*) FROM "sqlite_master" WHERE "TYPE"='table' AND "name"=:name"#) { statement in
            
            try! statement.parameter(":name").bind(name)
        }
        
        guard let tableCount = statement?.row.first?.integerValue else {
            
            fatalError("Unexpected database structure.")
        }
        
        return tableCount != 0
    }
    
    @discardableResult
    public func export(to path: String, options: OpenOption = []) throws -> SQLite3 {
        
        let options: OpenOption = OpenOption([.readwrite]).union(options)
        
        let source = self
        let destination = try SQLite3(path: path, options: options)
        
        guard let backup = sqlite3_backup_init(destination.pDB, "main", source.pDB, "main") else {
            
            throw ErrorCode(on: destination)!
        }
        
        sqlite3_backup_step(backup, -1)
        sqlite3_backup_finish(backup)
        
        if let errorCode = ErrorCode(on: destination) {
            
            throw errorCode
        }
        
        return destination
    }
}

