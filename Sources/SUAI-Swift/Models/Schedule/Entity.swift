//
//  Entity.swift
//  SUAI-Swift
//
//  Created by viktor.volkov on 25.12.2019.
//

import Foundation

public struct Entity {
    
    public let name: String
    public let type: Type
    let codes: Code
}

public struct Entities {
    
    public let groups: [Entity]
    public let auditories: [Entity]
    public let teachers: [Entity]
}

struct Code {
    
    let session: String?
    let semester: String?
}

struct EntityCode {
    
    let name: String
    let value: String
}

struct EntityCodes {
    
    let type: Type
    let codes: [EntityCode]
}
