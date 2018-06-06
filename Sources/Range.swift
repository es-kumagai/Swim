//
//  Range.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 12/14/17.
//

/// EXPERIMENTAL
public struct PartialRange<Bound> where Bound : Comparable {

    public var lowerBound: Bound?
    public var upperBound: Bound?
}

extension PartialRange : RangeExpression {
    
    public func relative<C>(to collection: C) -> Range<Bound> where C : Collection, Bound == C.Index {
        
        switch (lowerBound, upperBound) {
            
        case let (lowerBound?, upperBound?):
            return (lowerBound ..< upperBound as Range).relative(to: collection)
            
        case let (nil, upperBound?):
            return (...upperBound).relative(to: collection)
            
        case let (lowerBound?, nil):
            return (lowerBound...).relative(to: collection)
            
        case (nil, nil):
            fatalError("Invalid range: \(self).")
        }
    }
    
    public func contains(_ element: PartialRange<Bound>.Bound) -> Bool {
        
        switch (lowerBound, upperBound) {
            
        case let (lowerBound?, upperBound?):
            return (lowerBound ... upperBound as ClosedRange).contains(element)
            
        case let (nil, upperBound?):
            return (...upperBound).contains(element)
            
        case let (lowerBound?, nil):
            return (lowerBound...).contains(element)
            
        case (nil, nil):
            return false
        }
    }
}

extension PartialRange {

    public init(uncheckedBounds bounds: (lower: Bound?, upper: Bound?)) {
        
        lowerBound = bounds.lower
        upperBound = bounds.upper
    }
}

public prefix func ..<<Bound>(maximum: Bound) -> PartialRange<Bound> where Bound : Comparable {
    
    return PartialRange(lowerBound: nil, upperBound: maximum)
}

public postfix func ...<Bound>(minimum: Bound) -> PartialRange<Bound> where Bound : Comparable {
    
    return PartialRange(lowerBound: minimum, upperBound: nil)
}

public func ..<<Bound>(minimum: Bound, maximum: Bound) -> PartialRange<Bound> where Bound : Comparable {
    
    return PartialRange(lowerBound: minimum, upperBound: maximum)
}

extension PartialRange : Equatable {

    public static func == (lhs: PartialRange<Bound>, rhs: PartialRange<Bound>) -> Bool {

        return lhs.lowerBound == rhs.lowerBound
            && lhs.upperBound == rhs.upperBound
    }
    
    public static func ~= (pattern: PartialRange<Bound>, value: Bound) -> Bool {
        
        return pattern.contains(value)
    }
}
