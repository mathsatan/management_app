//
//  EmployeeList.Interactor.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import Foundation

protocol EmployeeListInteracting: ListInteractor {
    
    func refreshItems()
    func removeItem(at indexPath: IndexPath)
    func insert(item: EmployeeList.Entity)
    func moveItem(from old: IndexPath, to new: IndexPath)
}

protocol EmployeeListInteractorOutput: AnyObject {

    func didUpdateEntity()
}

extension EmployeeList {

    final class Interactor {

        // MARK: - Public properties

        weak var output: EmployeeListInteractorOutput!

        // MARK: - Private properties

        private var employeeWorker = EmployeeWorker(coreDataStack: AppDelegate.shared.coreDataStack)
        private var dataSource = SectionDataSource<Entity>()
        
        // MARK: - Init

        init() {
            self.refreshItems()
        }
        
        func refreshItems() {
            employeeWorker.fetchItems()
            let entities: [Entity] = employeeWorker.fetchedObjects.enumerated().compactMap {
                switch $0.element {
                case let accountant as Accountant:
                    let accountantType: EmployeeEntity.Accountant.AccountantType
                    if let stringType = accountant.type?.name, let type = EmployeeEntity.Accountant.AccountantType(rawValue: stringType) {
                        accountantType = type
                    } else {
                        accountantType = .none
                    }
                    
                    let item: EmployeeList.Entity.Item = .accountant(EmployeeEntity.Accountant(name: accountant.name,
                                                                                               salary: accountant.salary,
                                                                                               lunchTime: accountant.lunch_time,
                                                                                               workplaceNumber: accountant.workplace_number,
                                                                                               type: accountantType))
                    
                    return EmployeeList.Entity(id: $0.offset, item: item)
                case let employee as Employee:
                    let item: EmployeeList.Entity.Item = .employee(EmployeeEntity.Employee(name: employee.name,
                                                                                           salary: employee.salary,
                                                                                           lunchTime: employee.lunch_time,
                                                                                           workplaceNumber: employee.workplace_number))
                    return EmployeeList.Entity(id: $0.offset, item: item)
                case let manager as Manager:
                    let item: EmployeeList.Entity.Item = .manager(EmployeeEntity.Manager(name: manager.name,
                                                                                         salary: manager.salary,
                                                                                         receptionHours: manager.reception_hours))
                    return EmployeeList.Entity(id: $0.offset, item: item)
                default:
                    return nil
                }
            }
            let accountants: [Entity] = entities.filter { $0.type == .accountant }
            let employees: [Entity] = entities.filter { $0.type == .employee }
            let managers: [Entity] = entities.filter { $0.type == .manager }
            dataSource.removeAll()
            dataSource.insertSection(Section(items: accountants), at: 0)
            dataSource.insertSection(Section(items: employees), at: 1)
            dataSource.insertSection(Section(items: managers), at: 2)
            output?.didUpdateEntity()
        }
        
        func insert(item: EmployeeList.Entity) {
            employeeWorker.insert(item: item, isDefaultSort: employeeWorker.isDefaultSort) { [weak self] result in
                switch result {
                case .success(let isOk):
                    if isOk {
                        self?.refreshItems()
                    }
                case .failure(let error):
                    print("Insertion error has occured: \(error)")
                }
            }
        }
    }
}

// MARK: - Business logic

extension EmployeeList.Interactor: EmployeeListInteracting {

    typealias Item = EmployeeList.Entity
    
    func numberOfSections() -> Int {
        return dataSource.numberOfSections()
    }
    
    func numberOfItems(in section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }
    
    func item(at indexPath: IndexPath) -> Item {
        return dataSource.item(at: indexPath)
    }
    
    func removeItem(at indexPath: IndexPath) {
        let item = dataSource.item(at: indexPath)
        guard let object = employeeWorker.fetchedObjects[safeIndex: item.id] else {
            return
        }
        if employeeWorker.delete(item: object) {
            refreshItems()
        }
    }
    
    func moveItem(from old: IndexPath, to new: IndexPath) {
        if old == new {
            return
        }
        if employeeWorker.isDefaultSort {
            employeeWorker.assignIndexes(to: employeeWorker.fetchedObjects) { [weak self] result in
                switch result {
                case .success(let isOk):
                    if isOk {
                        self?.updateMovedItem(from: old, to: new)
                    }
                case .failure(let error):
                    print("Moving error has occured: \(error)")
                }
            }
        } else {
            updateMovedItem(from: old, to: new)
        }
    }
}

// MARK: - Private methods

private extension EmployeeList.Interactor {
    
    func updateMovedItem(from old: IndexPath, to new: IndexPath) {
        let updatedOrderNumber: Float
        if new.row == 0 {
            let movedItemID = dataSource.item(at: new).id
            updatedOrderNumber = employeeWorker.fetchedObjects[movedItemID].orderNumber / 2
        } else {
            let movedItemID = dataSource.item(at: new).id
            let prev = dataSource.item(at: IndexPath(row: new.row - 1, section: new.section))
            updatedOrderNumber = (employeeWorker.fetchedObjects[prev.id].orderNumber + employeeWorker.fetchedObjects[movedItemID].orderNumber) / 2.0
        }
        let person = employeeWorker.fetchedObjects[dataSource.item(at: old).id]
        
        employeeWorker.update(person: person, orderNumber: updatedOrderNumber) { [weak self] result in
            switch result {
            case .success(let isOk):
                if isOk {
                    self?.refreshItems()
                }
            case .failure(let error):
                print("Moving error has occured: \(error)")
            }
        }
    }
}
