//
//  Loader.swift
//  SUAI-Swift
//
//  Created by viktor.volkov on 26.12.2019.
//

import Foundation



class Loader {
    
    let session = URLSession(configuration: .default)
    
    func performRequest(url: URL, result: @escaping ResultClosure<Data>) {
        
        let task = session.dataTask(with: url) {
            data, _, e in
            
            if let err = e {
                result(.failure(err))
            }
            if let data = data {
                result(.success(data))
            }
        }
        task.resume()
    }
    
    func performRequest(url: URL?, result: @escaping ResultClosure<Data>) {
        
        guard let url = url else {
            return
        }
        
        performRequest(url: url, result: result)
    }
}

protocol NewsLoader {
    
}

enum SUAI {
    
    static let schedule = ScheduleProvider()
}
