//
//  ScheduleLoader.swift
//  SUAI-Swift
//
//  Created by viktor.volkov on 27.12.2019.
//

import Foundation

protocol ScheduleLoaderProtocol {
    
    func loadEntities(result: @escaping ResultRawDataClosure)
    func loadSchedule(for entity: Entity, result: @escaping ResultRawDataClosure)
}

class ScheduleLoader {
    
    typealias UrlKeyedTuple = (URL?, ReferenceWritableKeyPath<ScheduleLoader.RawData, Data?>)
    
    class RawData {
        
        var semester: Data?
        var session: Data?
    }
    
    private enum Constants {
        
        enum Queue {
            static let entity = "com.entity.queue"
            static let schedule = "com.schedule.queue"
        }
    }
    
    let loader = Loader()
    
    private func loadEntities(from url: URL?,
                              in group: DispatchGroup,
                              result: @escaping ResultClosure<Data>) {
        
        group.enter()
        
        loader.performRequest(url: url) {
            res in
            
            result(res)
            group.leave()
        }
    }
    
    private func performLoadingTask(in queue: DispatchQueue,
                                    containers: [UrlKeyedTuple],
                                    result: @escaping ResultRawDataClosure) {
        
        let group = DispatchGroup()
        
        let codesData = RawData()
        
        containers.forEach {
            url, path in
            
            queue.async(group: group) {
                [unowned self] in
                
                self.loadEntities(from: url, in: group) {
                    res in
                    
                    if case .success(let data) = res {
                        codesData[keyPath: path] = data
                    }
                }
            }
        }
        group.notify(queue: .main) {
            result(.success(codesData))
        }
    }
}

extension ScheduleLoader: ScheduleLoaderProtocol {
    
    func loadEntities(result: @escaping ResultRawDataClosure) {
        
        let queue = DispatchQueue(label: Constants.Queue.entity)
        
        let containers = [
            (UrlBuilder.build(for: .session), \RawData.session),
            (UrlBuilder.build(for: .semester), \RawData.semester),
        ]
        
        performLoadingTask(in: queue, containers: containers, result: result)
    }
    
    func loadSchedule(for entity: Entity, result: @escaping ResultRawDataClosure) {
        
        let queue = DispatchQueue(label: Constants.Queue.schedule)
        
        let containers = [
            (UrlBuilder.build(for: entity.type,
                              schedule: .session,
                              id: String(entity.codes.session ?? "")), \RawData.session),
            (UrlBuilder.build(for: entity.type,
                              schedule: .semester,
                              id: entity.codes.semester ?? ""), \RawData.semester)
        ]
        
        performLoadingTask(in: queue, containers: containers, result: result)
    }
}
