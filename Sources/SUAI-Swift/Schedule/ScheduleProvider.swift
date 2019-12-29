//
//  ScheduleProvider.swift
//  SUAI-Swift
//
//  Created by viktor.volkov on 27.12.2019.
//

import Foundation

protocol ScheduleProviderProtocol {
    func loadEntities(result: @escaping ResultClosure<Entities>)
    func loadSchedule(for entity: Entity, result: @escaping ResultClosure<Schedule>)
}

class ScheduleProvider {
    
    private enum Constants {
        static let separator = " - "
    }
    
    private let loader = ScheduleLoader()
    
    private func mergeCodes(session: [EntityCodes], semester: [EntityCodes]) -> Entities? {
        
        let keys = Type.allCases
        var values = [Type: [Entity]]()
        
        keys.forEach {
            key in
            
            let codesSem = semester.first { $0.type == key }?.codes ?? []
            let codesSess = session.first { $0.type == key }?.codes ?? []
            
            let dictSem = codesSem.reduce(into: [String: Entity]()) {
                let name = $1.name.components(separatedBy: Constants.separator).first ?? $1.name
                $0[name] = Entity(name: $1.name,
                                  type: key,
                                  codes: Code(session: nil, semester: $1.value))
            }
            let dictSess = codesSess.reduce(into: [String: Entity]()) {
                let name = $1.name.components(separatedBy: Constants.separator).first ?? $1.name
                $0[name] = Entity(name: $1.name,
                                  type: key,
                                  codes: Code(session: $1.value, semester: nil))
            }
            values[key] = dictSem
                .merging(dictSess) {
                    sem, sess -> Entity in
                    
                    Entity(name: sem.name,
                           type: key,
                           codes: Code(session: sess.codes.session, semester: sem.codes.semester))
                }
            .map { $1 }
            .sorted { $0.name < $1.name }
        }
        
        guard let groups = values[Type.group],
            let auditories = values[Type.auditory],
            let teachers = values[Type.teacher] else {
            return nil
        }
        return Entities(groups: groups, auditories: auditories, teachers: teachers)
    }
    
    private func parse(codes: ScheduleLoader.RawData) throws -> (sess: [EntityCodes], sem: [EntityCodes]) {
        let sessionCodes = try Parser.entities(from: codes.session, type: Type.ScheduleType.session)
        let semesterCodes = try Parser.entities(from: codes.semester, type: Type.ScheduleType.semester)
        return (sessionCodes, semesterCodes)
    }
    
    private func parse(schedules: ScheduleLoader.RawData) throws -> (sess: [Day], sem: [Day]) {
        let session = try Parser.schedule(from: schedules.session)
        let semester = try Parser.schedule(from: schedules.semester)
        return (session, semester)
    }
}

extension ScheduleProvider: ScheduleProviderProtocol {
    
    func loadEntities(result: @escaping ResultClosure<Entities>) {
        
        loader.loadEntities {
            [unowned self] res in
            
            switch res {
            case .success(let codes):
                do {
                    let parsedCodes = try self.parse(codes: codes)
                    guard let mergedResult = self.mergeCodes(session: parsedCodes.sess, semester: parsedCodes.sem) else {
                        // TODO: Return error code
                        return
                    }
                    result(.success(mergedResult))
                } catch let err {
                    result(.failure(err))
                }
            case .failure(let err):
                result(.failure(err))
            }
        }
    }
    
    func loadSchedule(for entity: Entity, result: @escaping ResultClosure<Schedule>) {
        
        loader.loadSchedule(for: entity) {
            res in
            
            switch res {
            case .success(let schedules):
                let parsedSchedule = try? self.parse(schedules: schedules)
                guard let sched = parsedSchedule else {
                    // TODO: Return error code
                    return
                }
                let schedule = Schedule(entity: entity, semester: sched.sem, session: sched.sess)
                result(.success(schedule))
            case .failure(let err):
                result(.failure(err))
            }
        }
    }
}
