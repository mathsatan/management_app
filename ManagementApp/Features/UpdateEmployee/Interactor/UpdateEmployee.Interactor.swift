//
//  UpdateEmployee.Interactor.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import Foundation

protocol UpdateEmployeeInteracting: AnyObject {

    var entity: UpdateEmployee.Entity { get }
    var mode: UpdateEmployee.Mode { get }
    func updateAccountant(_ accountant: EmployeeEntity.Accountant)
    func updateManager(_ manager: EmployeeEntity.Manager)
    func updateEmployee(_ employee: EmployeeEntity.Employee)
}

protocol UpdateEmployeeInteractorOutput: AnyObject {

    func didUpdateEntity()
}

extension UpdateEmployee {

    final class Interactor {

        // MARK: - Public properties

        weak var output: UpdateEmployeeInteractorOutput!
        private(set) var entity: UpdateEmployee.Entity
        private(set) var mode: UpdateEmployee.Mode
        
        // MARK: - Init

        init(mode: UpdateEmployee.Mode) {
            self.mode = mode
            switch mode {
            case .create(let employeeType):
                self.entity = Interactor.initialEntity(type: employeeType)
            case .update(let entity):
                self.entity = entity
            }
        }
    }
}

// MARK: - Business logic

extension UpdateEmployee.Interactor: UpdateEmployeeInteracting {

    static func initialEntity(type: EmployeeType) -> UpdateEmployee.Entity {
        switch type {
        case .accountant:
            return UpdateEmployee.Entity(id: 0, item: .accountant(.initial()))
        case .employee:
            return UpdateEmployee.Entity(id: 0, item: .employee(.initial()))
        case .manager:
            return UpdateEmployee.Entity(id: 0, item: .manager(.initial()))
        }
    }
    
    func updateAccountant(_ accountant: EmployeeEntity.Accountant) {
        entity = UpdateEmployee.Entity(id: entity.id, item: .accountant(accountant))
        output?.didUpdateEntity()
    }
    
    func updateManager(_ manager: EmployeeEntity.Manager) {
        entity = UpdateEmployee.Entity(id: entity.id, item: .manager(manager))
        output?.didUpdateEntity()
    }
    
    func updateEmployee(_ employee: EmployeeEntity.Employee) {
        entity = UpdateEmployee.Entity(id: entity.id, item: .employee(employee))
        output?.didUpdateEntity()
    }
}
