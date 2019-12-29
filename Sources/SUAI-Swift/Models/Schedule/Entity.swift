//
//  Entity.swift
//  SUAI-Swift
//
//  Created by viktor.volkov on 25.12.2019.
//

import Foundation

struct Entity {
    
    let name: String
    let type: Type
    let codes: Code
}

struct Entities {
    
    let groups: [Entity]
    let auditories: [Entity]
    let teachers: [Entity]
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
