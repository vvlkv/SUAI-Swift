//
//  Types.swift
//  SUAI-Swift
//
//  Created by viktor.volkov on 28.12.2019.
//

import Foundation

enum Type: String, RawRepresentable, CaseIterable {
    
    enum ScheduleType {
        case session, semester
    }
    
    private enum Constants {
        
        struct ScheduleKeys {
            let group: String
            let teacher: String
            let building: String
            let auditory: String
        }
        
        enum Codes {
            
            static let session = ScheduleKeys(group: "ctl00$cphMain$ctl03",
                                              teacher: "ctl00$cphMain$ctl04",
                                              building: "ctl00$cphMain$ctl05",
                                              auditory: "ctl00$cphMain$ctl06")
            
            static let semester = ScheduleKeys(group: "ctl00$cphMain$ctl05",
                                              teacher: "ctl00$cphMain$ctl06",
                                              building: "ctl00$cphMain$ctl07",
                                              auditory: "ctl00$cphMain$ctl08")
        }
    }
    case group
    case teacher
    case building
    case auditory
    
    init?(from code: String, type: Type.ScheduleType) {
        
        var codeKeys: Constants.ScheduleKeys
        if type == .semester {
            codeKeys = Constants.Codes.semester
        } else {
            codeKeys = Constants.Codes.session
        }
        let codes: [(String, Type)] = [
            (codeKeys.group, .group),
            (codeKeys.teacher, .teacher),
            (codeKeys.building, .building),
            (codeKeys.auditory, .auditory)
        ]
        for (raw, val) in codes {
            if raw == code {
                self = val
                return
            }
        }
        return nil
    }
}

enum WeekType: String {
    case up
    case down = "dn"
    case full
}

enum PairType {
    
    private enum Constants {
        static let lection = "Л"
        static let practice = "ПР"
        static let lab = "ЛР"
        static let courseProject = "КП"
        static let courseWork = "КР"
    }
    
    case lection
    case practice
    case laboratory
    case courseProject
    case courseWork
    case unknown
    
    init(from raw: String) {
        
        let targetKey: (String, PairType)? = [
            (Constants.lection, .lection),
            (Constants.practice, .practice),
            (Constants.lab, .laboratory),
            (Constants.courseProject, .courseProject),
            (Constants.courseWork, .courseWork),
        ].first {
                rawVal, val -> Bool in
                
                rawVal == raw
        }
        
        self = targetKey?.1 ?? .unknown
    }
}
