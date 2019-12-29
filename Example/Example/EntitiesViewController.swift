//
//  EntitiesViewController.swift
//  Example
//
//  Created by viktor.volkov on 29.12.2019.
//  Copyright © 2019 viktor.volkov. All rights reserved.
//

import UIKit
import SUAI_Swift

class EntitiesViewController: UIViewController {
    
    private enum Constants {
        static let title = "Entities"
        static let cellID = "EntityCellID"
        static let groups = "groups"
        static let auditories = "auditories"
        static let teachers = "teachers"
    }
    
    private enum Layouts {
        static let edge: CGFloat = 16
    }
    
    private lazy var entitiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var entitiesControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(didChangeSegmentedValue), for: .valueChanged)
        return control
    }()
    
    private var entities: [[Entity]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        SUAI.schedule.loadEntities {
            [unowned self] result in
            
            if case .success(let entities) = result {
                self.didLoad(entities: entities)
            }
        }
    }
    
    private func setupUI() {
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        }
        title = Constants.title
        
        view.addSubview(entitiesControl)
        entitiesControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layouts.edge).isActive = true
        entitiesControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layouts.edge).isActive = true
        entitiesControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Layouts.edge).isActive = true
        
        view.addSubview(entitiesTableView)
        entitiesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        entitiesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        entitiesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        entitiesTableView.bottomAnchor.constraint(equalTo: entitiesControl.topAnchor, constant: -Layouts.edge).isActive = true
    }
    
    @objc private func didChangeSegmentedValue() {
        entitiesTableView.reloadData()
    }
    
    private func didLoad(entities: Entities) {
        self.entities = [entities.groups, entities.auditories, entities.teachers]
        entitiesControl.insertSegment(withTitle: Constants.teachers, at: 0, animated: true)
        entitiesControl.insertSegment(withTitle: Constants.auditories, at: 0, animated: true)
        entitiesControl.insertSegment(withTitle: Constants.groups, at: 0, animated: true)
        entitiesControl.selectedSegmentIndex = 0
        didChangeSegmentedValue()
    }
}

extension EntitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entities?[entitiesControl.selectedSegmentIndex].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID) ?? UITableViewCell(style: .default, reuseIdentifier: Constants.cellID)
        cell.textLabel?.text = entities?[entitiesControl.selectedSegmentIndex][indexPath.row].name
        return cell
    }
}

extension EntitiesViewController: UITableViewDelegate {
    
}
