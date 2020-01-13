//
//  Managements.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/01/13.
//

extension Collection {
    
    /// [Swim] Returns the indexes, each index is the specified distance from start index of the collection.
    ///
    /// - parameter predicate: The predicate using pickup indexes.
    ///
    /// - returns: Indexes, each index is a index offset by `distance` from start index.
    public func indexes(where predicate: (Element) throws -> Bool) rethrows -> [Index] {
        
        try enumerated().compactMap {
            
            try predicate($0.element) ? index(startIndex, offsetBy: $0.offset) : nil
        }
    }

    public func removed(contentsAt indexes: [Index]) -> [Element] {
     
        enumerated().compactMap { offset, element in
            
            let i = index(startIndex, offsetBy: offset)
            
            guard indexes.contains(i) else {
                
                return element
            }
            
            return nil // means 'remove'
        }
    }
}

extension RangeReplaceableCollection {
    
    /// [Swim] Removes the elements of a sequence of indexes from the collection.
    ///
    /// - parameter indexes: The indexes to point elements that will remove from the array.
    public mutating func remove(contentsAt indexes: [Index]) {
        
        for index in indexes.uniqued().sorted(by: >) {
            
            remove(at: index)
        }
    }
}

extension Collection where Element : Equatable {
    
    /// [Swim] Returns the indexes, each index is the specified distance from start index of the collection.
    ///
    /// - parameter predicate: The predicate using pickup indexes.
    ///
    /// - returns: Indexes, each index is a index offset by `distance` from start index.
    public func indexes(of elements: [Element]) -> [Index] {

        indexes(where: elements.contains)
    }

    /// [Swim] Get an Array that has distinct elements.
    /// If same element found, keep the first element only.
    public func uniqued() -> [Element] {

        reduce(into: []) { result, element in
            
            if !result.contains(element) {
                
                result.append(element)
            }
        }
    }
    
}
