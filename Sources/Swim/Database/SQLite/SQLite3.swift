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
    
    /// Create a new SQLite instance with given store.
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
	
	func makeStatement(with sql: String, prepare: ((Statement) throws -> Void)? = nil) throws -> Statement {
		
		let statement = try Statement(db: self, sql: sql)
		
		try prepare?(statement)
		
		return statement
	}
    
    /// Make a new statement with `sql` and execute `step` method.
    ///
    /// - Parameters:
    ///   - sql: The SQL sentence of this statement.
    ///   - prepare: Evaluate to prepare this statement before executing `step` method.
    /// - Throws: SQLite3.ResultCode
    /// - Returns: New executed statement if `step` method returns true, otherwise nil.
	@discardableResult
	func execute(sql: String, prepare: ((Statement) throws -> Void)? = nil) throws -> Statement? {
		
		let statement = try makeStatement(with: sql)
		
		try prepare?(statement)
		
        switch try statement.step() {
        
        case true:
            return statement
            
        case false:
            return nil
        }
	}
}

extension SQLite3 {
    
    public convenience init(path: String, options: OpenOption) throws {
        
        try self.init(store: Store.path(path), options: options)
    }
}

