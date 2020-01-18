//
//  SchedulePresenter.swift
//  Example
//
//  Created by viktor.volkov on 12.01.2020.
//  Copyright © 2020 viktor.volkov. All rights reserved.
//

import SUAI_Swift

class SchedulePresenter {
    
    private enum Constants {
        static let session = "session"
        static let semester = "semester"
    }
    
    private let selectedEntity: Entity
    var schedule: Schedule?
    
    weak var view: ScheduleViewControllerInput?
    
    private var selectedSchedule: [Day]? {
        return controlIndex == 0 ? schedule?.semester : schedule?.session
    }
    
    private var controlIndex = 0
    
    init(entity: Entity) {
        selectedEntity = entity
        SUAI.schedule.loadSchedule(for: selectedEntity) {
            [weak self] res in
            
            if case .success(let schedule) = res {
                self?.schedule = schedule
                self?.view?.reload()
            }
        }
    }
}

extension SchedulePresenter: ScheduleViewControllerOutput {
    
    func numberOfSections() -> Int {
        return selectedSchedule?.count ?? 0
    }
    
    func numberOfRows(in section: Int) -> Int {
        return selectedSchedule?[section].pairs.count ?? 0
    }
    
    func segmentsForControl() -> [String] {
        return [Constants.session, Constants.semester]
    }
    
    func titleForCell(at indexPath: IndexPath) -> String {
        return selectedSchedule?[indexPath.section].pairs[indexPath.row].name ?? ""
    }
    
    func titleForHeader(in section: Int) -> String? {
        return selectedSchedule?[section].name ?? ""
    }
    
    func viewControllerForPresent(at indexPath: IndexPath) -> UIViewController? {
        return nil
    }
    
    func didChangeSelectedControl(_ index: Int) {
        controlIndex = index
    }
}
