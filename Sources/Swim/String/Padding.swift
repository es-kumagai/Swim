//
//  StringProtocol.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/03/26
//  
//

public extension StringProtocol {
    
    func paddingTop(with character: Element, toLength length: Int) -> String {
        
        let paddingCount = length - count
        
        guard paddingCount > 0 else {
            return String(self)
        }
        
        return String(repeating: character, count: paddingCount) + self
    }
}
