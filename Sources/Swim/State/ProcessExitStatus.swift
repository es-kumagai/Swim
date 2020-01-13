//
//  State.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/01/13.
//


@available(*, unavailable, renamed: "ProcessExitStatus")
public enum ProcessingState {}

/// Expressing Process Exit Status
public struct ProcessExitStatus {
    
    var code: Int

    public init<T: BinaryInteger>(code: T) {

        self.code = Int(code)
    }
}

extension ProcessExitStatus {

    static let passed = ProcessExitStatus(code: 0)
}

extension ProcessExitStatus : ExpressibleByIntegerLiteral {

    public init(integerLiteral value: Int) {
        
        self.init(code: value)
    }
}

extension ProcessExitStatus {
    
    /**
    Returns a Boolean value that indicates whether the value is equal to .Passed.
    */
    public var passed: Bool {
        
        code.meansProcessPassed
    }
    
    /**
    Returns a Boolean value that indicates whether the value is equal to .Aborted.
    */
    public var aborted: Bool {

        code.meansProcessAborted
    }
}

extension Numeric {
    
    public var meansProcessPassed: Bool {
        
        self == 0
    }
    
    public var meansProcessAborted: Bool {
        
        self != 0
    }
}
