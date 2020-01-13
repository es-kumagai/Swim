//
//  Continuous.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/01/13.
//

/// [Swim] A enumeration type expressing continuity state.
///
/// - continue:   An indication of continuity continue.
/// - abort:      An indication of continuity abort.
public enum Continuous {
    
    case `continue`
    case abort
    
    /// [Swim] A boolean value indicates continuity state of this instance.
    public var canContinue: Bool {
        
        self ~= .continue
    }
}

extension ProcessExitStatus {
    
    public init(representedBy state: Continuous, code: Int = -1) {
        
        switch state {
            
        case .continue:
            self = .passed
            
        case .abort:
            self = .aborted(in: code)
        }
    }
}
