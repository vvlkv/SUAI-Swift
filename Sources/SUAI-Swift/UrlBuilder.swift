//
//  UrlBuilder.swift
//  SUAI-Swift
//
//  Created by viktor.volkov on 27.12.2019.
//

import Foundation

enum UrlBuilder {
    
    private enum Constants {
        enum URL {
            static let scheme = "http"
            static let session = "raspsess.guap.ru"
            static let semester = "rasp.guap.ru"
        }
        enum Query {
            private static let group = "g"
            private static let teacher = "p"
            private static let building = "b"
            private static let auditory = "r"
            
            static func name(for type: Type) -> String {
                typealias QueryConst = Constants.Query
                switch type {
                case .teacher:
                    return QueryConst.teacher
                case .group:
                    return QueryConst.group
                case .auditory:
                    return QueryConst.auditory
                case .building:
                    return QueryConst.building
                default:
                    fatalError("undefined Type value")
                }
            }
        }
    }
    
    static func build(for scheduleType: Type.ScheduleType) -> URL? {
        var urlComponents = URLComponents()
        typealias UrlConst = Constants.URL
        urlComponents.scheme = UrlConst.scheme
        urlComponents.host = scheduleType == .semester ? UrlConst.semester : UrlConst.session
        return urlComponents.url
    }
    
    static func build(for type: Type, schedule: Type.ScheduleType, id: String) -> URL? {
        
        guard let url = build(for: schedule) else {
            return nil
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let query = URLQueryItem(name: Constants.Query.name(for: type), value: id)
        urlComponents?.queryItems = [query]
        return urlComponents?.url
    }
}
