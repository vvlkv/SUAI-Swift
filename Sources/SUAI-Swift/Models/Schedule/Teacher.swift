//
//  Teacher.swift
//  SUAI-Swift
//
//  Created by viktor.volkov on 29.12.2019.
//

import Foundation

public struct Teacher {
    
    public let name: String
    public let degree: String
    
    init(rawName: String) {
        let components = rawName.components(separatedBy: " - ")
        if components.count == 2 {
            name = components[0]
            degree = components[1]
        } else {
            name = rawName
            degree = ""
        }
    }
    
    static func create(from raw: String) -> [Teacher] {
        return (raw.components(separatedBy: ": ")
        .last?
        .components(separatedBy: "; ") ?? [])
        .map { Teacher(rawName: $0) }
    }
}
