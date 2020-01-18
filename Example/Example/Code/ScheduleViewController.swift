//
//  ScheduleViewController.swift
//  Example
//
//  Created by viktor.volkov on 29.12.2019.
//  Copyright © 2019 viktor.volkov. All rights reserved.
//

import UIKit

protocol ScheduleViewControllerOutput: AnyObject {
    
    var view: ScheduleViewControllerInput? { get set }
    
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func segmentsForControl() -> [String]
    func titleForCell(at indexPath: IndexPath) -> String
    func titleForHeader(in section: Int) -> String?
    func viewControllerForPresent(at indexPath: IndexPath) -> UIViewController?
    func didChangeSelectedControl(_ index: Int)
}

protocol ScheduleViewControllerInput: AnyObject {
    
    var output: ScheduleViewControllerOutput? { get set }
    
    func reload()
}

class ScheduleViewController: UIViewController, ScheduleViewControllerInput {
    
    private enum Constants {
        static let cellID = "EntityCellID"
    }
    
    private enum Layouts {
        static let edge: CGFloat = 8
    }
    
    var output: ScheduleViewControllerOutput?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        }
        
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
        output?.didChangeSelectedControl(entitiesControl.selectedSegmentIndex)
        entitiesTableView.reloadData()
    }
    
    func reload() {
        
        guard let segments = output?.segmentsForControl() else {
            return
        }
        
        segments.forEach {
            title in
            
            entitiesControl.insertSegment(withTitle: title, at: .zero, animated: true)
        }
        entitiesControl.selectedSegmentIndex = 0
        entitiesTableView.reloadData()
    }
}

extension ScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return output?.numberOfSections() ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return output?.titleForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID) ?? UITableViewCell(style: .default, reuseIdentifier: Constants.cellID)
        cell.textLabel?.text = output?.titleForCell(at: indexPath)
        return cell
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = output?.viewControllerForPresent(at: indexPath) else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
