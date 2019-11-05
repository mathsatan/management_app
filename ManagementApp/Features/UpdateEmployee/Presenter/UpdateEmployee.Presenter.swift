//
//  UpdateEmployee.Presenter.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

protocol UpdateEmployeePresenterOutput: AnyObject {
    
    func didCreateEntity(_ presenter: UpdateEmployeePresenting, entity: UpdateEmployee.Entity)
    func didUpdateEntity(_ presenter: UpdateEmployeePresenting, entity: UpdateEmployee.Entity)
}

protocol UpdateEmployeePresenting: AnyObject {

    func viewDidLoad()
    func didChangeSegmentIndex(_ selectedSegmentIndex: Int)
    func didObtainContent(_ content: UpdateEmployeeViewController.ViewModel.Content)
    func didTapSaveButton()
    func didTapCancelButton()
}

extension UpdateEmployee {

    final class Presenter {

        // MARK: - Public properties

        weak var view: UpdateEmployeeView!
        weak var presenterOutput: UpdateEmployeePresenterOutput?
        var router: UpdateEmployeeRouting!
        var interactor: UpdateEmployeeInteracting!
        
        // MARK: - Private properties
        
        private static let numberFormatter: NumberFormatter = {
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale.current
            numberFormatter.numberStyle = .currency
            return numberFormatter
        }()
    }
}

// MARK: - Presentation logic

extension UpdateEmployee.Presenter: UpdateEmployeePresenting {

    func viewDidLoad() {
        view.viewModel = viewModel()
    }
    
    func didChangeSegmentIndex(_ selectedSegmentIndex: Int) {
        guard let type = EmployeeType(rawValue: selectedSegmentIndex) else {
            return
        }
        switch type {
        case .manager:
            interactor.updateManager(.initial())
        case .accountant:
            interactor.updateAccountant(.initial())
        case .employee:
            interactor.updateEmployee(.initial())
        }
    }
    
    func didTapSaveButton() {
        switch interactor.mode {
        case .create:
            presenterOutput?.didCreateEntity(self, entity: interactor.entity)
        case .update:
            presenterOutput?.didUpdateEntity(self, entity: interactor.entity)
        }
        router.close()
    }
    
    func didTapCancelButton() {
        router.close()
    }
    
    func didObtainContent(_ content: UpdateEmployeeViewController.ViewModel.Content) {
        switch content {
        case .accountant(let accountant):
            let entity = EmployeeEntity.Accountant(name: accountant.name,
                                                   salary: salary(from: accountant.salary),
                                                   lunchTime: accountant.lunchTime,
                                                   workplaceNumber: workplaceNumber(from: accountant.workplaceNumber),
                                                   type: .materials)
            interactor.updateAccountant(entity)
        case .manager(let manager):
            let entity = EmployeeEntity.Manager(name: manager.name,
                                                salary: salary(from: manager.salary),
                                                receptionHours: manager.receptionHours)
            interactor.updateManager(entity)
        case .employee(let employee):
            let entity = EmployeeEntity.Employee(name: employee.name,
                                                 salary: salary(from: employee.salary),
                                                 lunchTime: employee.lunchTime,
                                                 workplaceNumber: workplaceNumber(from: employee.workplaceNumber))
            interactor.updateEmployee(entity)
        }
    }
}

// MARK: - UpdateEmployeeInteractorOutput

extension UpdateEmployee.Presenter: UpdateEmployeeInteractorOutput {
    
    func didUpdateEntity() {
        view.viewModel = viewModel()
    }
}

// MARK: - ViewModel

private extension UpdateEmployee.Presenter {
    
    func viewModel() -> UpdateEmployeeViewController.ViewModel {
        switch interactor.entity.item {
        case .accountant(let accountant):
            return .init(mode: mode(interactor.mode),
                         segment: interactor.entity.type.rawValue,
                         content: .accountant(accountantViewModel(accountant)))
        case .employee(let employee):
            return .init(mode: mode(interactor.mode),
                         segment: interactor.entity.type.rawValue,
                         content: .employee(employeeViewModel(employee)))
        case .manager(let manager):
            return .init(mode: mode(interactor.mode),
                         segment: interactor.entity.type.rawValue,
                         content: .manager(managerViewModel(manager)))
        }
    }
    
    func accountantViewModel(_ accountant: EmployeeEntity.Accountant) -> AccountantView.ViewModel {
        let typeTitles = [R.string.common.accountantTypePayrollText(), R.string.common.accountantTypeMaterialsText()]
        return .init(name: accountant.name,
                     salary: salaryFormatting(value: accountant.salary),
                     lunchTime: accountant.lunchTime,
                     workplaceNumber: "#\(accountant.workplaceNumber)",
                     accountantTypes: typeTitles,
                     accountType: accountant.type.rawValue)
    }
    
    func managerViewModel(_ manager: EmployeeEntity.Manager) -> ManagerView.ViewModel {
        return .init(name: manager.name, salary: salaryFormatting(value: manager.salary), receptionHours: manager.receptionHours)
    }
    
    func employeeViewModel(_ employee: EmployeeEntity.Employee) -> EmployeeView.ViewModel {
        return .init(name: employee.name,
                     salary: salaryFormatting(value: employee.salary),
                     lunchTime: employee.lunchTime,
                     workplaceNumber: "#\(employee.workplaceNumber)")
    }
    
    func salaryFormatting(value: Int32) -> String {
        return UpdateEmployee.Presenter.numberFormatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    func salary(from value: String) -> Int32 {
        return Int32(truncating: UpdateEmployee.Presenter.numberFormatter.number(from: value) ?? 0)
    }
    
    func workplaceNumber(from value: String) -> Int32 {
        return Int32(value.filter { $0.isNumber }) ?? 0
    }
    
    func mode(_ mode: UpdateEmployee.Mode) -> UpdateEmployeeViewController.ViewModel.Mode {
        switch mode {
        case .create:
            return .create
        case .update:
            return .update
        }
    }
}
