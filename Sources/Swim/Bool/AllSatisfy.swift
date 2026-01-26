//
//  AllSatisfy.swift
//  NDIAudioTool
//
//  Created by 熊谷 友宏 on 2026/01/25.
//

@resultBuilder
public struct AllSatisfy {
    public static func buildBlock(_ components: Bool...) -> Bool {
        components.allSatisfy(\.self)
    }
}
