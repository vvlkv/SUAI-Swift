//
//  EntitiesPresenter.swift
//  Example
//
//  Created by viktor.volkov on 12.01.2020.
//  Copyright © 2020 viktor.volkov. All rights reserved.
//

import SUAI_Swift

class EntitiesPresenter {
    
    private enum Constants {
        static let groups = "groups"
        static let auditories = "auditories"
        static let teachers = "teachers"
    }
    
    weak var view: ScheduleViewControllerInput?
    
    private var entities: [[Entity]]?
    private var selectedEntities: [Entity]? {
        return entities?[controlIndex]
    }
    private var controlIndex = 0
    
    init() {
        SUAI.schedule.loadEntities {
            [weak self] res in
            
            if case .success(let entities) = res {
                self?.entities = [entities.groups, entities.auditories, entities.teachers]
                self?.view?.reload()
            }
        }
    }
}

extension EntitiesPresenter: ScheduleViewControllerOutput {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return selectedEntities?.count ?? 0
    }
    
    func segmentsForControl() -> [String] {
        return [Constants.teachers, Constants.auditories, Constants.groups]
    }
    
    func titleForCell(at indexPath: IndexPath) -> String {
        return selectedEntities?[indexPath.row].name ?? ""
    }
    
    func titleForHeader(in section: Int) -> String? {
        return nil
    }
    
    func viewControllerForPresent(at indexPath: IndexPath) -> UIViewController? {
        guard let entity = selectedEntities?[indexPath.row] else {
            return nil
        }
        let vc = ScheduleViewController()
        vc.title = entity.name
        let presenter = SchedulePresenter(entity: entity)
        presenter.view = vc
        vc.output = presenter
        return vc
    }
    
    func didChangeSelectedControl(_ index: Int) {
        controlIndex = index
    }
}
