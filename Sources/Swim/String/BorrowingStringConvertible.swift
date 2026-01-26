//
//  BorrowingStringConvertible.swift
//  NDIAudioTool
//
//  Created by 熊谷 友宏 on 2026/01/23.
//

public protocol BorrowingStringConvertible: ~Copyable {
    var description: String { borrowing get }
}

public extension DefaultStringInterpolation {
    
    mutating func appendInterpolation(_ value: borrowing some BorrowingStringConvertible) {
        appendInterpolation(value.description)
    }
}

public extension String {
    
    init(describing value: borrowing some BorrowingStringConvertible) {
        self.init(describing: value.description)
    }
}
