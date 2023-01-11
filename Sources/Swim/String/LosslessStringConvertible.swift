//
//  LosslessStringConvertible.swift
//  
//  
//  Created by Tomohiro Kumagai on 2023/01/11
//  
//

extension LosslessStringConvertible where Self : CaseIterable {
    
    public init?(_ description: some StringProtocol) {
        guard let value = Self.allCases.first(where: { $0.description == description }) else {
            return nil
        }
        
        self = value
    }
}
