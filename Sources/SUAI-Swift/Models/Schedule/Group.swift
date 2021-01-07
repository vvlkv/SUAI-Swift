//
//  Group.swift
//  SUAI-Swift
//
//  Created by viktor.volkov on 29.12.2019.
//

import Foundation

public struct Group {
    
    public let name: String
    
    static func groups(from raw: String) -> [String] {
        return (raw.components(separatedBy: ": ")
            .last?
            .components(separatedBy: "; ") ?? [])
    }
}
