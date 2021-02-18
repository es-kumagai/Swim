//
//  SubscriptMapper.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2021/02/18.
//

/// [Swim] A type that provide a feature of accessing something using subscript.
/// The given target are kept by closure which is held by this instance.
public struct SubscriptMapper<Target : Collection> {

    public typealias ElementPicker = (Target.Index) -> Target.Element
    public typealias IndicesPicker = () -> Target.Indices
    
    private var elementPicker: ElementPicker
    private var indicesPicker: IndicesPicker

    public init(elementPicker: @escaping ElementPicker, indicesPicker: @escaping IndicesPicker) {
        
        self.elementPicker = elementPicker
        self.indicesPicker = indicesPicker
    }
}

extension SubscriptMapper {

    public var count: Int {
        
        return indices.count
    }

    public var indices: Target.Indices {
        
        return indicesPicker()
    }
    
    public subscript (index: Target.Index) -> Target.Element? {
        
        return elementPicker(index)
    }
}
