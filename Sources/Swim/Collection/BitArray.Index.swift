//
//  BitArray.Index.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/03/25
//  
//

extension BitArray {
    
    public struct Index : Sendable, Hashable {
        
        public let byteIndex: Int
        public let msbBitIndex: Int
    }
}

extension BitArray.Index : Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        (lhs.byteIndex, lhs.msbBitIndex) < (rhs.byteIndex, rhs.msbBitIndex)
    }
}

extension BitArray.Index : Strideable {
    
    public func distance(to other: Self) -> Int {
        other.bitWidth - bitWidth
    }
    
    public func advanced(by n: Int) -> Self {
        .init(bitWidth + n)
    }
}

extension BitArray.Index : CustomStringConvertible {
    
    public var description: String {
        String(bitWidth)
    }
}

extension BitArray.Index : CustomDebugStringConvertible {
    
    public var debugDescription: String {
        "(Byte: \(byteIndex), Bit: \(msbBitIndex))"
    }
}

extension BitArray.Index : ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

public extension BitArray.Index {
    
    init(_ bitWidth: Int) {
        
        (byteIndex, msbBitIndex) = bitWidth
            .quotientAndRemainder(dividingBy: 8)
    }
    
    var bitWidth: Int {
        byteIndex * 8 + msbBitIndex
    }
    
    var byteWidth: Int {
        byteIndex + (msbBitIndex > 0 ? 1 : 0)
    }
    
    var bitMask: Byte {
        Byte.pickupMaskInMSB(msbBitIndex)
    }
    
    func isBitSet(inTargetByte targetByte: Byte) -> Bool {
        targetByte & bitMask != 0
    }
}

