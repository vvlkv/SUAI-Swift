//
//  Parser.swift
//  SUAI-Swift
//
//  Created by viktor.volkov on 26.12.2019.
//

import Foundation
import SwiftSoup

class Parser {
    
    private enum Constants {
        
        enum Attrs {
            static let `class` = "class"
        }
        enum Tags {
            static let h3 = "h3"
            static let h4 = "h4"
            static let div = "div"
        }
        enum Class {
            static let study = "study"
            static let groups = "groups"
            static let preps = "preps"
        }
        enum Keys: String {
            case rasp
            case result
            case em
            case select
            case name
            case value
        }
        
        static let prohibitedNames = ["- нет -", "--", "/.", "/.", "//*"]
    }
    
    static func entities(from data: Data?, type: Type.ScheduleType) throws -> [EntityCodes] {
        guard let data = data, let result = String(data: data, encoding: .utf8) else {
            return []
        }
        
        let doc = try SwiftSoup.parse(result)
        let raspClass = try doc.getElementsByClass(Constants.Keys.rasp.rawValue)
        let spans = try raspClass.select(Constants.Keys.select.rawValue)
        var codes = [EntityCodes]()
        for span in spans {
            let attr = try span.attr(Constants.Keys.name.rawValue)
            guard let type = Type(from: attr, type: type) else {
                continue
            }
            var entities = [EntityCode]()
            for spanChild in span.children() {
                let name = try spanChild.text()
                if Constants.prohibitedNames.contains(name) {
                   continue
                }
                let value = try spanChild.attr(Constants.Keys.value.rawValue)
                entities.append(EntityCode(name: name,
                                           value: value))
            }
            codes.append(EntityCodes(type: type,
                                     codes: entities))
        }
        
        return codes
    }
    
    static func schedule(from data: Data?) throws -> [Day] {
        
        guard let data = data, let result = String(data: data, encoding: .utf8) else {
            return []
        }
        
        let doc = try SwiftSoup.parse(result)
        let resultClass = try doc.getElementsByClass(Constants.Keys.result.rawValue)
        guard let children = resultClass.first()?.children() else {
            return []
        }
        var days = [Day]()

        let daysElements = children.split {
            e -> Bool in
            
            e.tagName() == Constants.Tags.h3
        }.dropFirst()
        
        for slice in daysElements {
            days.append(try parseDay(from: slice))
        }
        
        return days
    }
    
    private static func parseDay(from slice: Slice<Elements>) throws -> Day {
        let indice = (slice.startIndex - 1)..<slice.endIndex
        var dayName = ""
        var pairTime = ""
        var pairs = [Pair]()
        for element in slice.base[indice] {
            if element.tagName() == Constants.Tags.h3 {
                pairs.removeAll()
                dayName = try element.text()
            }
            if element.tagName() == Constants.Tags.h4 {
                pairTime = try element.text()
            }
            if element.tagName() == Constants.Tags.div {
                pairs.append(try parsePair(from: element, with: pairTime))
            }
        }
        return Day(name: dayName, weekday: 0, pairs: pairs)
    }
    
    private static func parsePair(from element: Element, with time: String) throws -> Pair {
        
        let pairTypeElements = try element.select("b")
        let weekType = WeekType(rawValue: (try pairTypeElements.attr(Constants.Attrs.class))) ?? .full
        let pairType = PairType(from: try pairTypeElements.last()?.text() ?? "")
        
        let studyElement = try element.getElementsByClass(Constants.Class.study).select("span")
        let studyText = try studyElement.text().components(separatedBy: " – ").dropFirst().first ?? ""
        let auditory = Auditory(raw: try studyElement.select("em").text())
        
        let teacherText = try element.getElementsByClass(Constants.Class.preps).text()
        let teachers = Teacher.create(from: teacherText)
        let groups = Group.groups(from: try element.getElementsByClass(Constants.Class.groups).text())
        
        return Pair(name: studyText,
                          time: time,
                          pairType: pairType,
                          weekType: weekType,
                          auditory: auditory,
                          teachers: teachers,
                          groups: groups)
    }
}
