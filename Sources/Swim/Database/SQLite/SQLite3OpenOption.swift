//
//  SQLite3OpenOption.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/11.
//

import SQLite3

extension SQLite3 {
    
    /// An option set for opening SQLite database.
    public struct OpenOption : OptionSet {
        
        /// The raw value of this instance.
        public var rawValue: Int32
        
        /// Create a new option set representing the given value.
        /// - Parameter rawValue: The value for creating.
        public init(rawValue: Int32) {
            
            self.rawValue = rawValue
        }
        
        /// The database is opened in read-only mode. If the database does not already exist, an error is returned.
        public static var readonly : OpenOption {
            
            OpenOption(rawValue: SQLITE_OPEN_READONLY)
        }
        
        /// The database is opened for reading and writing if possible, or reading only if the file is write protected by the operating system. In either case the database must already exist, otherwise an error is returned.
        public static var readwrite : OpenOption {
            
            OpenOption(rawValue: SQLITE_OPEN_READWRITE)
        }
        
        /// The database is opened for reading and writing, and is created if it does not already exist.
        public static var create : OpenOption {
            
            OpenOption(rawValue: SQLITE_OPEN_CREATE)
        }
        
        /// The filename can be interpreted as a URI if this flag is set.
        public static var uri : OpenOption {
            
            OpenOption(rawValue: SQLITE_OPEN_URI)
        }
        
        /// The database will be opened as an in-memory database. The database is named by the "filename" argument for the purposes of cache-sharing, if shared cache mode is enabled, but the "filename" is otherwise ignored.
        public static var memory : OpenOption {
            
            OpenOption(rawValue: SQLITE_OPEN_MEMORY)
        }
        
        /// he new database connection will use the "multi-thread" threading mode. This means that separate threads are allowed to use SQLite at the same time, as long as each thread is using a different database connection.
        public static var noMutex : OpenOption {
            
            OpenOption(rawValue: SQLITE_OPEN_NOMUTEX)
        }
        
        /// The new database connection will use the "serialized" threading mode. This means the multiple threads can safely attempt to use the same database connection at the same time. (Mutexes will block any actual concurrency, but in this mode there is no harm in trying.)
        public static var fullMutex : OpenOption {
            
            OpenOption(rawValue: SQLITE_OPEN_FULLMUTEX)
        }
        
        /// The database is opened shared cache enabled, overriding the default shared cache setting provided by sqlite3_enable_shared_cache().
        public static var sharedCache : OpenOption {
            
            OpenOption(rawValue: SQLITE_OPEN_SHAREDCACHE)
        }
        
        /// The database is opened shared cache disabled, overriding the default shared cache setting provided by sqlite3_enable_shared_cache().
        public static var privateCache : OpenOption {
            
            OpenOption(rawValue: SQLITE_OPEN_PRIVATECACHE)
        }
    }
}
