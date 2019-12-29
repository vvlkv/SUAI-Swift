//
//  Auditory.swift
//  SUAI-Swift
//
//  Created by viktor.volkov on 29.12.2019.
//

import Foundation

struct Auditory {

    let number: String
    let building: String
    let descripton: String
    
    init(raw: String) {
        descripton = raw.replacingOccurrences(of: "– ", with: "")
        let components = descripton.components(separatedBy: " ")
        number = components.last ?? ""
        building = components.first ?? ""
    }
}
