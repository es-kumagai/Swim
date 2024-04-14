//
//  Base32.swift
//
//
//  Created by Tomohiro Kumagai on 2024/03/24
//
//

public enum Base32 {
    
}

private extension Character {
    
    static func - (lhs: Character, rhs: Character) -> UInt8 {
        
        guard let lhs = lhs.asciiValue, let rhs = rhs.asciiValue else {
            fatalError("Both '\(lhs)' and '\(rhs)' must be ASCII characters.")
        }
        
        return lhs - rhs
    }
}

private extension Array<UInt8> {
    
    
}

private extension Base32 {
    
    struct InvalidFormatError : Error {}
    static let invalidFormat = InvalidFormatError()
    
    static func value(from word: Character) throws -> Byte {
        
        switch word {
        case "A" ... "Z":
            Byte(word - "A")
            
        case "2" ... "7":
            Byte(word - "2")
            
        case _:
            throw invalidFormat
        }
    }
    
    static func bit5(of value: UInt8) -> [Bool] {

        [
            value & 0b10000 != 0,
            value & 0b01000 != 0,
            value & 0b00100 != 0,
            value & 0b00010 != 0,
            value & 0b00001 != 0
        ]
    }
    
    static func trimPadding<Text>(of encodedText: Text) throws -> Text.SubSequence where Text : StringProtocol {
        
        let components = encodedText.split(separator: "=")
        
        guard let component = components.first, components.dropFirst().isEmpty else {
            throw invalidFormat
        }
        
        return component
    }
}

public extension Base32 {
    
    static func decodingAsCString(_ encodedText: borrowing some StringProtocol) -> String? {
        decoding(encodedText).map(String.init(cString:))
    }
    
    static func decoding(_ encodedText: borrowing some StringProtocol) -> [Byte]? {
        
        do {
            let bit5Values = try trimPadding(of: encodedText)
                .map(value(from:))
            let bit8Values = BitArray(bit5Values, eachSignificantBitsInMSB: 5)
            
            guard bit8Values.count.isMultiple(of: 8) else {
                return nil
            }
            
            return bit8Values.withUnsafeBytes { bytes, bitWidth in
                bytes.map(Byte.init(_:))
            }
        } catch {
            return nil
        }
    }
}
