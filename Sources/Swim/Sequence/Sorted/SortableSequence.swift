//
//  SortableSequence.swift
//  
//  
//  Created by Tomohiro Kumagai on 2023/12/13
//  
//

public protocol SortableSequence : Sequence {
    init(_ values: some Sequence<Element>)
}

extension SortableSequence {
    
    public init() {
        self.init([])
    }
}

extension Array : SortableSequence {}
extension Set : SortableSequence {}
