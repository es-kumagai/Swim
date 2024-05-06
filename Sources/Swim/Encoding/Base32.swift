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
    
    static let encodedWordUnitCount = 8
    static let bitUnitCount = 5

    static func value(from word: Character) throws -> UInt5 {
        
        guard let asciiValue = word.asciiValue else {
            throw invalidFormat
        }
        
        return try value(from: Byte(asciiValue))
    }
    
    static func value(from word: Byte) throws -> UInt5 {
        
        let word = UInt8(word)
        
        switch word {
            
        case 0x41 ... 0x5A: /* A-Z */
            return UInt5(word - 0x41)
            
        case 0x32 ... 0x37: /* 2-7 */
            return UInt5(0b11010 + word - 0x32)
            
        case _:
            throw invalidFormat
        }
    }

    static func word(from value: UInt5) -> Byte {
        
        switch value {
        case 0b00000 ... 0b11001:
            Byte(0x41 + UInt8(value))
            
        case 0b11010 ... 0b11111:
            Byte(0x32 - 0b11010 + UInt8(value))
            
        case _:
            fatalError("Unexpected value: \(value) in UInt5.")
        }
    }
    
    static let paddingWord: Byte = 0x3d

    static func trimPadding(of bits: BitArray) throws -> BitArray.SubSequence {

        let bitCountInLastUnit = bits.count % encodedWordUnitCount
        let effectiveBitCount = bits.count - bitCountInLastUnit
        
        let effectiveEndIndex = bits.index(bits.startIndex, offsetBy: effectiveBitCount)
        
        let effectiveBits = bits[0 ..< effectiveEndIndex]
        let ineffectiveBits = bits[effectiveEndIndex ..< bits.endIndex]
        
        guard !ineffectiveBits.contains(.one) else {
            throw invalidFormat
        }
        
        return effectiveBits
    }
    static func trimPadding<Text>(of encodedText: Text) throws -> Text.SubSequence where Text : StringProtocol {

        guard !encodedText.isEmpty else {
            return encodedText.prefix(0)
        }
        
        let paddingWord = Character(UnicodeScalar(UInt8(paddingWord)))
        let lastIndex = encodedText.lastIndex(where: { $0 != paddingWord }) ?? encodedText.indices.last!
        let trimmedText = encodedText[encodedText.startIndex ... lastIndex]

        guard trimmedText.firstIndex(of: paddingWord) == nil else {
            throw invalidFormat
        }
        
        return trimmedText
    }
}

public extension Base32 {

    static func encodingAsCString(_ text: borrowing some StringProtocol) -> String {
        
        let encodedText = encoding(text)
        return String(cString: encodedText)
    }

    static func encodingAsCString(_ data: borrowing [Byte]) -> String {

        let encodedData = encoding(data)
        return String(cString: encodedData)
    }

    static func encoding(_ text: some StringProtocol) -> [Byte] {
        
        let data = text.utf8.map(Byte.init(_:))
        return encoding(data)
    }

    static func encoding(_ data: [Byte]) -> [Byte] {
        
        let bits = BitArray(contentsOf: data)
        let units = [UInt5](bits, paddingBitInLSB: .zero)
        let words = units.map(word(from:))
        
        let wordCountInLastUnit = words.count % encodedWordUnitCount
        let insufficientWordCount = encodedWordUnitCount - wordCountInLastUnit
        
        return switch insufficientWordCount {
            
        case 8:
            words
            
        default:
            words + .init(repeating: paddingWord, count: insufficientWordCount)
        }
    }

    static func decodingAsCString(_ encodedText: borrowing some StringProtocol) -> String? {
        
        guard let text = decoding(encodedText) else {
            return nil
        }

        return String(cString: text)
    }
    
    static func decoding(_ encodedText: borrowing some StringProtocol) -> [Byte]? {
        
        guard let trimmedText = try? trimPadding(of: encodedText) else {
            return nil
        }
        
        guard let units = try? trimmedText.map(value(from:)) else {
            return nil
        }
        
        let bits = BitArray(bitPatternsOf: units)
        
        guard let trimmedBits = try? trimPadding(of: bits) else {
            return nil
        }
        
        return trimmedBits.uncheckedPackingInBytes()
    }
}
