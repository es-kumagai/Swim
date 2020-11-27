//
//  StringConcat.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/11/27.
//

/// [Swim] This is a function builder that concat each strings with separator "".
@_functionBuilder
public class StringConcat {
    
    public typealias Component = [String?]
    
    public class var separator: String {
        
        return ""
    }
    
    public class func buildFinalResult(_ component: Component) -> String {
        
        return component
            .compactMap { $0 }
            .joined(separator: separator)
    }
    
    public class func buildExpression(_ statement: String?) -> Component {
        
        return [statement]
    }
    
    public class func buildExpression<T>(_ statements: [T]) -> Component {
        
        return statements.map(String.init(describing:))
    }
    
    public class func buildExpression<T>(_ statement: T?) -> Component {
        
        return [statement.map(String.init(describing:))]
    }
    
    // This method work without inherit in sub class.
    public static func buildBlock(_ statements: Component ...) -> Component {
        
        return statements.flatMap { $0 }
    }
    
    public class func buildIf(_ component: Component?) -> Component {

        if let component = component {

            return component
        }
        else {

            return [nil]
        }
    }
    
    public class func buildEither(first: Component) -> Component {
        
        return first
    }
    
    public class func buildEither(second: Component) -> Component {
        
        return second
    }
}

/// [Swim] This is a function builder that concat each strings with separator " ".
@_functionBuilder
public final class SpaceSeparatedList : StringConcat {
    
    public override class var separator: String {
        
        return " "
    }
    
    // FIXME: WORKAROUND: Swift compiler cannot find this method in inherited class.
    public override class func buildFinalResult(_ component: Component) -> String {
        
        super.buildFinalResult(component)
    }
    
    // FIXME: WORKAROUND: Swift compiler cannot find this method in inherited class.
    public override class func buildExpression(_ statement: String?) -> Component {
        
        return super.buildExpression(statement)
    }
    
    // FIXME: WORKAROUND: Swift compiler cannot find this method in inherited class.
    public override class func buildExpression<T>(_ statements: [T]) -> Component {
        
        return super.buildExpression(statements)
    }
    
    // FIXME: WORKAROUND: Swift compiler cannot find this method in inherited class.
    public override class func buildExpression<T>(_ statement: T?) -> Component {
        
        return super.buildExpression(statement)
    }
    
    // FIXME: WORKAROUND: Swift compiler cannot find this method in inherited class.
    public override class func buildIf(_ component: Component?) -> Component {

        return super.buildIf(component)
    }
    
    // FIXME: WORKAROUND: Swift compiler cannot find this method in inherited class.
    public override class func buildEither(first: Component) -> Component {

        return super.buildEither(first: first)
    }

    // FIXME: WORKAROUND: Swift compiler cannot find this method in inherited class.
    public override class func buildEither(second: Component) -> Component {

        return super.buildEither(second: second)
    }
}


@_functionBuilder
public final class CommaSeparatedList : StringConcat {
    
    public override class var separator: String {
        
        return ", "
    }
    
    // FIXME: WORKAROUND: Swift compiler cannot find this method in inherited class.
    public override class func buildFinalResult(_ component: Component) -> String {
        
        super.buildFinalResult(component)
    }
    
    // FIXME: WORKAROUND: Swift compiler cannot find this method in inherited class.
    public override class func buildExpression(_ statement: String?) -> Component {
        
        return super.buildExpression(statement)
    }
    
    // FIXME: WORKAROUND: Swift compiler cannot find this method in inherited class.
    public override class func buildExpression<T>(_ statements: [T]) -> Component {
        
        return super.buildExpression(statements)
    }
    
    // FIXME: WORKAROUND: Swift compiler cannot find this method in inherited class.
    public override class func buildExpression<T>(_ statement: T?) -> Component {
        
        return super.buildExpression(statement)
    }
    
    // FIXME: WORKAROUND: Swift compiler cannot find this method in inherited class.
    public override class func buildIf(_ component: Component?) -> Component {

        return super.buildIf(component)
    }
    
    // FIXME: WORKAROUND: Swift compiler cannot find this method in inherited class.
    public override class func buildEither(first: Component) -> Component {

        return super.buildEither(first: first)
    }

    // FIXME: WORKAROUND: Swift compiler cannot find this method in inherited class.
    public override class func buildEither(second: Component) -> Component {

        return super.buildEither(second: second)
    }
}
