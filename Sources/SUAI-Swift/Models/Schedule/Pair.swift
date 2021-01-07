//
//  Pair.swift
//  SUAI-Swift
//
//  Created by viktor.volkov on 29.12.2019.
//

import Foundation

public struct Pair {
    
    public let name: String
    public let time: String
    public let pairType: PairType
    public let weekType: WeekType
    public let auditory: Auditory
    public let teachers: [Teacher]
    public let groups: [String]
}
