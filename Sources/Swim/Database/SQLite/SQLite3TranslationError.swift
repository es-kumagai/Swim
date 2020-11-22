//
//  SQLite3TranslationError.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/23.
//

extension SQLite3 {
    
    public enum TranslationError : Error {
        
        case uncompatibleSwiftType(Any.Type)
    }
    
}
