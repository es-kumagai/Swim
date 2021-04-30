//
//  SQLite3SQLBundle.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 2020/12/03.
//

@resultBuilder
public struct SQLBundle {
    
    public static func buildExpression<Target : SQLite3Translateable, Kind : SQLite3SQLKind>(_ component: SQLite3.SQL<Target, Kind>) -> String {
        
        return component.text()
    }
    
    public static func buildExpression(_ component: String) -> String {
        
        return component
    }
    
    public static func buildBlock(_ components: String ...) -> [String] {
        
        return components
    }
}
