//
//  SubscriptMapper.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2021/02/18.
//

/// [Swim] A type that provide a feature of accessing something using subscript.
/// The given closures are kept by closure which is held by this instance.
public struct SubscriptMapper<T, Index : Comparable> {

    private var elementPicker: (Index) -> T
    private var indicesPicker: () -> Range<Index>

    public init(elementPicker: @escaping (Index) -> T, indicesPicker: @escaping () -> Range<Index>) {
        
        self.elementPicker = elementPicker
        self.indicesPicker = indicesPicker
    }

    public var indices: Range<Index> {
        
        return indicesPicker()
    }
    
    public subscript (index: Index) -> T {
        
        return elementPicker(index)
    }
}

extension SubscriptMapper where T : ExpressibleByNilLiteral, Index == Int {
    
    public init() {
        
        self.init(
            
            elementPicker: { _ in nil },
            indicesPicker: { Range(0 ... 0) }
        )
    }
}
