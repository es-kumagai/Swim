//
//  SubscriptMapper.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2021/02/18.
//

/// [Swim] A type that provide a feature of accessing something using subscript.
/// The target that is contained by the given closures is held by this instance.
@available(*, unavailable, message: "No longer available.")
public struct SubscriptMapper<Target, Index : Strideable, Indices : Collection> where Indices.Element == Index {

    public typealias ElementPicker = (Index) -> Target
    public typealias IndicesPicker = () -> Indices
}
