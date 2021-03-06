//
//  SQLite3StatementIterator.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/11.
//

extension SQLite3 {
    
    public struct StatementIterator : IteratorProtocol, Sequence {
        
        private var statement: Statement?
        
        internal init(statement: Statement, keepCurrentStep: Bool) throws {
            
            if !keepCurrentStep {
                
                try statement.reset()
            }
            
            self.statement = statement
        }
        
        public mutating func next() -> SQLite3.Statement? {
            
            guard statement != nil else {
                
                return nil
            }

            guard try! statement!.step() else {
                
                statement = nil
                return nil
            }
            
            return statement
        }
    }
}
