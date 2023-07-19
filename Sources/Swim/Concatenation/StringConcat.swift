//
//  StringConcat.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/27.
//

extension String {
    
    /// [Swim] Build a string that join strings given as arguments with `separator`.
    /// - Parameters:
    ///   - separator: A separator that uses to join each strings.
    ///   - predicate: A function to build a string from strings.
    /// - Returns: A string that was joined given strings.
    public static func concat(separator: String = "", @BundleInArray<String> _ predicate: () throws -> Array<String>) rethrows -> String {
        
        return try predicate().joined(separator: separator)
    }
}

/// [Swim] This is a function builder that concat each strings with separator "".
@resultBuilder
open class StringConcat {
    
    public typealias Component = [String?]
    
    open class var separator: String {
        ""
    }
    
    open class var lineBreak: String {
        ""
    }
    
    open class var omitNil: Bool {
        true
    }
    
    open class func buildFinalResult(_ component: Component) -> String {
        
        return component
            .compactMap {
                guard !omitNil else {
                    return $0
                }

                return $0 ?? ""
            }
            .map { "\($0)\(lineBreak)" }
            .joined(separator: separator)
    }
    
    open class func buildExpression(_ statement: String?) -> Component {
        
        return [statement]
    }
    
    open class func buildExpression<T>(_ statements: [T]) -> Component {
        
        return statements.map(String.init(describing:))
    }
    
    open class func buildExpression<T>(_ statement: T?) -> Component {
        
        return [statement.map(String.init(describing:))]
    }
    
    // This method work without inherit in sub class.
    open class func buildBlock(_ statements: Component ...) -> Component {
        
        return statements.flatMap { $0 }
    }
    
    open class func buildIf(_ component: Component?) -> Component {

        if let component = component {

            return component
        }
        else {

            return [nil]
        }
    }
    
    open class func buildEither(first: Component) -> Component {
        
        return first
    }
    
    open class func buildEither(second: Component) -> Component {
        
        return second
    }
}

/// [Swim] This is a function builder that concat each strings with separator "\n".
@resultBuilder
public final class StringConcatWithNewline: StringConcat {
    
    public override class var lineBreak: String {
        "\n"
    }
    
    public override class var omitNil: Bool {
        false
    }
}

/// [Swim] This is a function builder that concat each strings with separator " ".
@resultBuilder
public final class SpaceSeparatedList : StringConcat {
    
    public override class var separator: String {
        " "
    }
    
    public override class var omitNil: Bool {
        false
    }
}


@resultBuilder
public final class CommaSeparatedList : StringConcat {
    
    public override class var separator: String {
        ","
    }
    
    public override class var omitNil: Bool {
        false
    }
}
