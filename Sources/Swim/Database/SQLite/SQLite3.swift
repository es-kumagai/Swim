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
        
        return statement.row.first!.integerValue
    }
    
    /// [Swim] Attach database
    /// - Parameters:
    ///   - databasePath: The path of a database to attach.
    ///   - name: The name of the database that is specified by `databasePath`.
    /// - Throws: SQLite3.ResultCode
    public func attach(databasePath: String, to name: String) throws {
        
        let path = SQLite3.quoted(databasePath)
        let name = SQLite3.fieldName(name)
        
        try execute(sql: "ATTACH DATABASE \(path) AS \(name)")
    }
}

extension SQLite3 {
    
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
}

