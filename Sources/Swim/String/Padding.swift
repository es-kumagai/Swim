//
//  Padding.swift
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

public extension String {
    
    init(_ value: some StringProtocol, topPaddingWith character: Character, toLength length: Int) {
        
        self = value.paddingTop(with: character, toLength: length)
    }
}
