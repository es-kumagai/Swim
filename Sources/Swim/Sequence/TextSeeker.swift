//
//  TextSeeker.swift
//  Swim
//  
//  Created by Tomohiro Kumagai on 2024/09/13
//  
//

import RegexBuilder

/// [Swim] A collection type that iterates over substrings found between
/// matches of a specified pattern in a text sequence.
///
/// `TextSeeker` allows you to find and extract substrings that occur between
/// matches of a regular expression pattern in a text. It is customizable via the
/// `truncator` and `excludeMatchingPart` parameters.
///
/// - The `truncator` parameter can be used to specify a pattern that, if
///   matched, truncates the match part and any text following it from the last matching part.
/// - The `excludeMatchingPart` parameter allows you to control whether the
///   matched part of the pattern is included in the resulting substrings.
public struct TextSeeker {
    
    public typealias Part = Range<String.Index>
    
    private let text: String
    private let parts: [Part]
    
    /// [Swim] Create an instance that seeks `text` for matching by `position` and returns a collection of substrings
    /// between each match; the last substring is truncated by `truncator`.
    ///
    /// - Parameter text: A text for seeking.
    /// - Parameter position: A regular expression component used to find the positions.
    /// - Parameter truncator: An optional pattern that, if matched, truncates
    ///   the resulting substring after the match.
    /// - Parameter excludeMatchingPart: A Boolean value that determines whether to
    ///   exclude the matched part of the pattern from the result.
    init<Text, Position>(_ text: consuming Text, matchingBy position: borrowing Position, truncateAfter truncator: Position? = nil, excludeMatchingPart: Bool = false) where Text: StringProtocol, Position: RegexComponent {
        
        let text = String(text)
        let endBound = text.endIndex

        var parts = text
            .matches(of: position)
            .map(\.range)
            .reduce(into: [Part]()) { parts, currentPart in
                
                let startBound = excludeMatchingPart ? currentPart.upperBound : currentPart.lowerBound
                
                guard !parts.isEmpty else {
                    
                    parts = [startBound ..< endBound]
                    return
                }
                
                let lastPart = parts.removeLast()
                
                parts.append(lastPart.lowerBound ..< currentPart.lowerBound)
                parts.append(startBound ..< endBound)
            }
                
        if let truncator, let lastMatch = parts.last {
            
            let lastPattern = Regex {
                #/^/#
                ZeroOrMore(.reluctant) {
                    #/./#
                }
                Lookahead {
                    truncator
                }
            }
            
            let lastText = text[lastMatch]
            
            if let terminationMatch = lastText.firstMatch(of: lastPattern) {
                parts.removeLast()
                parts.append(terminationMatch.range)
            }
        }
        
        self.text = text
        self.parts = parts
    }
}

extension TextSeeker: RandomAccessCollection {
    
    public var startIndex: Int {
        parts.startIndex
    }
    
    public var endIndex: Int {
        parts.endIndex
    }
    
    public subscript(position: Int) -> Substring {
        text[parts[position]]
    }
}

extension StringProtocol {
    
    /// [Swim] Seeks for matching by `position` and returns a collection of substrings
    /// between each match; the last substring is truncated by `truncator`.
    ///
    /// - Parameter position: A regular expression component used to find the positions.
    /// - Parameter truncator: An optional pattern that, if matched, truncates
    ///   the resulting substring after the match.
    /// - Parameter excludeMatchingPart: A Boolean value that determines whether to
    ///   exclude the matched part of the pattern from the result.
    /// - Returns: A `TextSeeker` object that allows iterating over the substrings
    ///   found between matches of the `position` pattern.
    borrowing func seek<Position>(matchingBy position: borrowing Position, truncateAfter truncator: Position? = nil, excludeMatchingPart: Bool = false) -> TextSeeker where Position: RegexComponent {
        TextSeeker(copy self, matchingBy: position, truncateAfter: truncator, excludeMatchingPart: excludeMatchingPart)
    }
}
