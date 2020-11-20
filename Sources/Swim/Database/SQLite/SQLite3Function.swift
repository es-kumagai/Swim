//
//  SQLite3Function.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/12.
//

extension SQLite3 {

    /// [Swim] Make `source` enclosing in a single quotation.
    ///
    /// - Parameter source: The text to enclose in a single quotation.
    /// - Returns: The text that enclosed in a single quotation.
    public static func quoted(_ source: String) -> String {
        
        let text = source
            .map(String.init)
            .map { word in
                
                if word == "'" {
                    
                    return "''"
                }
                else {
                    
                    return word
                }
            }
            .joined()
        
        return "'\(text)'"
    }
    
    /// [Swim] Make `name` enclosing in a double quotation.
    ///
    /// - Parameter name: The text to enclose in a double quotation.
    /// - Returns: The text that enclosed in a double quotation.
    public static func fieldName(_ name: String) -> String {
        
        let text = name
            .map(String.init)
            .map { word in
                
                if word == "\"" {
                    
                    return "\"\""
                }
                else {
                    
                    return word
                }
            }
            .joined()
        
        return "\"\(text)\""
    }
}
