//
//  CSV.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/09.
//

public struct CSV {
    
}

extension CSV {
    
    public enum ConversionError : Error {
        
        case invalidValue(String?, to: CSVColumnConvertible.Type)
        case columnsMismatch(line: String, columns: [AnyColumn])
        case unknownKeyPath(AnyColumn)
        case typeMismatch(value: Any.Type, property: Any.Type)
        case unexpected(Error)
    }
    
    public static private(set) var quoteWord: Character = "\""
    public static private(set) var separator: Character = ","
    
    public static func isQuoted(_ text: String) -> Bool {
        
        return text.first == quoteWord && text.last == quoteWord
    }

    /// [Swim] The string that removed quotation from this value.
    /// If this value is an illegal format (e.g. non-pair of quote word appears), the behavior of this method is undefined.
    /// - Returns: The string removed quotation.
    public static func extracted(_ text: String) -> String {
        
        guard !text.isEmpty, isQuoted(text) else {
            
            return text
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
    
    public static func removedTrailingNewline(of line: String) -> String {
    
        guard !line.isEmpty, line.last == "\n" else {
            
            return line
        }
        
        return String(line.prefix(line.count - 1))
    }
    
    public static func quoted(_ text: String) -> String {
        
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

    public static func split(_ text: String) -> [String?] {
        
        enum State {

            case beginOfValue
            case valuePart
            case insideOfQuote
            case quoteAppearedInValuePart
            case quoteAppearedInsideOfQuote
        }
        
        var result = Array<String?>()
        var letter = nil as String?

        var state = State.beginOfValue {
            
            didSet {

                if state == .beginOfValue {
                    
                    result.append(letter)
                    letter = nil
                }
            }
        }
        
        func stateChangeTo(_ newState: State) {
            
            state = newState
        }
        
        func keepToLetter<T>(_ word: T) {

            switch letter {
            
            case .none:
                letter = String(describing: word)
                
            case .some:
                letter!.append(String(describing: word))
            }
        }
        
        func keepToLetter<T>(_ word: T, stateChangeTo nextState: State) {
            
            keepToLetter(word)
            stateChangeTo(nextState)
        }
        
        for word in text {
            
            switch state {
            
            case .beginOfValue:
                
                switch word {
                
                case CSV.quoteWord:
                    keepToLetter("", stateChangeTo: .insideOfQuote)
                    
                case CSV.separator:
                    stateChangeTo(.beginOfValue)
                    
                case let word:
                    keepToLetter(word, stateChangeTo: .valuePart)
                }

            case .valuePart:

                switch word {
                
                case CSV.quoteWord:
                    keepToLetter(CSV.quoteWord)
                    
                case CSV.separator:
                    stateChangeTo(.beginOfValue)
            
                case let word:
                    keepToLetter(word)
                }
                
            case .insideOfQuote:
                
                switch word {
                
                case CSV.quoteWord:
                    stateChangeTo(.quoteAppearedInsideOfQuote)
                    
                case CSV.separator:
                    keepToLetter(CSV.separator)
                
                case let word:
                    keepToLetter(word)
                }
                
            case .quoteAppearedInsideOfQuote:
                
                switch word {
                
                case CSV.quoteWord:
                    keepToLetter(CSV.quoteWord, stateChangeTo: .insideOfQuote)
                    
                case CSV.separator:
                    stateChangeTo(.beginOfValue)
                    
                case let word:
                    keepToLetter(word, stateChangeTo: .insideOfQuote)
                }
                
            case .quoteAppearedInValuePart:
                
                switch word {
                
                case CSV.quoteWord:
                    keepToLetter(CSV.quoteWord, stateChangeTo: .valuePart)
                    
                case CSV.separator:
                    stateChangeTo(.beginOfValue)
                    
                case let word:
                    keepToLetter(word, stateChangeTo: .valuePart)
                }
            }
        }
        
        state = .beginOfValue

        return result
    }
}
