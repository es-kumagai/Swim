//
//  Trimming.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/09/07
//  
//

public extension StringProtocol {
    
    /// [Swim] Checks if the string ends with a newline character (`\n`).
    ///
    /// - Returns: `true` if this string ends with a newline character, otherwise `false`.
    var endsWithNewline: Bool {
        hasSuffix("\n")
    }
    
    /// [Swim] Remove a trailing newline (`\n`).
    ///
    /// - Returns `true` iff a trailing newline character was removed, otherwise `false`.
    @discardableResult
    mutating func removeTrailingNewline() -> Bool {
        
        guard endsWithNewline else {
            return false
        }
        
        self = removingTrailingNewline()
        return true
    }
    
    /// [Swim] Returns an instance removing a trailing newline character (`\n`).
    consuming func removingTrailingNewline() -> Self {
        
        guard endsWithNewline else {
            return self
        }

        return dropLast().withCString {
            Self.init(cString: $0)
        }
    }
}

extension String {
    
    /// [Swim] Remove a trailing newline (`\n`).
    ///
    /// - Returns `true` iff a trailing newline character was removed, otherwise `false`.
    @discardableResult
    mutating func removeTrailingNewline() -> Bool {
        
        guard hasSuffix("\n") else {
            return false
        }
        
        removeLast()
        return true
    }
    
    /// [Swim] Returns an instance removing a trailing newline character (`\n`).
    consuming func removingTrailingNewline() -> Substring {
        
        guard hasSuffix("\n") else {
            return dropLast(0)
        }
        
        return dropLast()
    }
}
