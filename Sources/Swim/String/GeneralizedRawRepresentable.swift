//
//  GeneralizedRawRepresentable.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/08/22
//  
//

public extension RawRepresentable where RawValue == String {
    
    init?(exactly rawValue: some StringProtocol) {
        self.init(rawValue: String(rawValue))
    }
}

public extension RawRepresentable where RawValue: BinaryInteger {
    
    init?(exactly rawValue: some BinaryInteger) {

        guard let rawValue = RawValue(exactly: rawValue) else {
            return nil
        }

        self.init(rawValue: rawValue)
    }
}

public extension RawRepresentable where RawValue: BinaryFloatingPoint {
    
    init?(exactly rawValue: some BinaryFloatingPoint) {
        
        guard let rawValue = RawValue(exactly: rawValue) else {
            return nil
        }
        
        self.init(rawValue: rawValue)
    }
}
