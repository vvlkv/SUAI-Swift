//
//  CustomTypes.swift
//  SUAI-Swift
//
//  Created by viktor.volkov on 29.12.2019.
//

import Foundation

public typealias ResultClosure<T> = ((Result<T, Error>) -> Void)
typealias ResultRawDataClosure = ResultClosure<ScheduleLoader.RawData>
