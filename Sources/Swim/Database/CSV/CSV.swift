//
//  CSV.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/09.
//

public struct CSV {
    
    public let quoteWord: Character
    public let separator: Character
    
    public init() {
        self.init(quoteWord: "\"", separator: ",")
    }
    
    public init(quoteWord: Character, separator: Character) {

        self.quoteWord = quoteWord
        self.separator = separator
    }
    
    public func isQuoted(_ text: some StringProtocol) -> Bool {
        
        return text.count >= 2 && text.first == quoteWord && text.last == quoteWord
    }

    /// [Swim] The string that removed quotation from this value.
    /// If this value is an illegal format (e.g. non-pair of quote word appears), the behavior of this method is undefined.
    /// - Returns: The string removed quotation.
    public func extracted(_ text: some StringProtocol) -> String? {
        
        guard isQuoted(text) else {

            return nil
        }

        var result = String()
        var escapeWordDetected = false
        
        result.reserveCapacity(text.count)
        
        let startIndex = text.index(after: text.startIndex)
        let endIndex = text.index(before: text.endIndex)
        
        for word in text[startIndex ..< endIndex] {
            
            if word == quoteWord {
                
                guard !escapeWordDetected else {
                    
                    escapeWordDetected = false
                    continue
                }
                
                escapeWordDetected = true
            }
            else {
                
                escapeWordDetected = false
            }
            
            result.append(word)
        }
        
        return result
    }
    
    public func removedTrailingNewline(of line: some StringProtocol) -> String {
    
        guard !line.isEmpty, line.last == "\n" else {
            
            return line.description
        }
        
        return String(line.prefix(line.count - 1))
    }
    
    public func quoted(_ value: some LosslessStringConvertible) -> String {
        
        quoted(String(value))
    }
    
    public func quoted(_ text: some StringProtocol) -> String {
        
        guard !text.isEmpty else {
            
            return String(repeating: quoteWord, count: 2)
        }
        
        var result = String()
        
        result.reserveCapacity(text.count * 2)
        
        for word in text {
            
            switch word {
            
            case quoteWord:
                result.append(String(repeating: quoteWord, count: 2))
                
            default:
                result.append(word)
            }
        }
        
        return "\(quoteWord)\(result)\(quoteWord)"
    }

    public func split(_ text: some StringProtocol) -> [String] {
        
        var result = Array<String>()
        var letter = ""

        var state = SplitingState.beginOfValue {
            
            didSet {

                if state == .beginOfValue {
                    
                    result.append(letter)
                    letter = ""
                }
            }
        }
        
        func stateChangeTo(_ newState: SplitingState) {
            
            state = newState
        }
        
        func keepToLetter<T>(_ word: T) {

            letter.append(String(describing: word))
        }
        
        func keepLetter<T>(_ word: T, stateChangeTo nextState: SplitingState) {
            
            keepToLetter(word)
            stateChangeTo(nextState)
        }
        
        for word in text {
            
            switch state {
            
            case .beginOfValue:
                
                switch word {
                
                case quoteWord:
                    keepLetter(quoteWord, stateChangeTo: .insideOfQuote)
                    
                case separator:
                    stateChangeTo(.beginOfValue)
                    
                case let word:
                    keepLetter(word, stateChangeTo: .valuePart)
                }

            case .valuePart:

                switch word {
                
                case quoteWord:
                    keepToLetter(quoteWord)
                    
                case separator:
                    stateChangeTo(.beginOfValue)
            
                case let word:
                    keepToLetter(word)
                }
                
            case .insideOfQuote:
                
                switch word {
                
                case quoteWord:
                    keepLetter(quoteWord, stateChangeTo: .quoteAppearedInsideOfQuote)
                    
                case separator:
                    keepToLetter(separator)
                
                case let word:
                    keepToLetter(word)
                }
                
            case .quoteAppearedInsideOfQuote:
                
                switch word {
                
                case quoteWord:
                    stateChangeTo(.insideOfQuote)
                    
                case separator:
                    stateChangeTo(.beginOfValue)
                    
                case let word:
                    keepLetter(word, stateChangeTo: .insideOfQuote)
                }
                
            case .quoteAppearedInValuePart:
                
                switch word {
                
                case quoteWord:
                    keepLetter(quoteWord, stateChangeTo: .valuePart)
                    
                case separator:
                    stateChangeTo(.beginOfValue)
                    
                case let word:
                    keepLetter(word, stateChangeTo: .valuePart)
                }
            }
        }
        
        state = .beginOfValue

        return result
    }}

extension CSV {
    
    public enum ConversionError : Error {
        
        case invalidValue(String, to: CSVColumnConvertible.Type)
        case columnsMismatch(line: String, columns: [AnyColumn])
        case unknownKeyPath(AnyColumn)
        case typeMismatch(value: Any.Type, property: Any.Type)
        case unexpected(Error)
    }
}

public extension CSV {
    
    static let standard = CSV()
    
    private enum SplitingState {
        
        case beginOfValue
        case valuePart
        case insideOfQuote
        case quoteAppearedInValuePart
        case quoteAppearedInsideOfQuote
    }
    
    @available(*, unavailable, renamed: "CSV.standard.quoteWord")
    static var quoteWord: Character { fatalError() }
    
    @available(*, unavailable, renamed: "CSV.standard.separator")
    static var separator: Character { fatalError() }

    @available(*, unavailable, renamed: "CSV.standard.isQuoted(_:)")
    static func isQuoted(_ text: some StringProtocol) -> Bool { fatalError() }
    
    @available(*, unavailable, renamed: "CSV.standard.extracted(_:)")
    static func extracted(_ text: some StringProtocol) -> String? { fatalError() }
    
    @available(*, unavailable, renamed: "CSV.standard.removedTrailingNewline(of:)")
    static func removedTrailingNewline(of line: some StringProtocol) -> String { fatalError() }
    
    @available(*, unavailable, renamed: "CSV.standard.quoted(_:)")
    static func quoted(_ text: some StringProtocol) -> String { fatalError() }
    
    @available(*, unavailable, renamed: "CSV.standard.split(_:)")
    static func split(_ text: some StringProtocol) -> [String] { fatalError() }
}
