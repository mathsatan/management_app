//
//  EmployeeList.Presenter.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

protocol EmployeeListPresenting: AnyObject {

    func viewDidLoad()
    func titleForHeader(in secion: Int) -> String?
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> EmployeeList.Cell
    
    func didMoveItem(from old: IndexPath, to new: IndexPath)
    func didTapRemoveItem(at indexPath: IndexPath)
    func didTapAddButton()
}

extension EmployeeList {

    final class Presenter<Interactor: EmployeeListInteracting> where Interactor.Item == Entity {

        // MARK: - Public properties

        weak var view: EmployeeListView!
        var router: EmployeeListRouting!
        var interactor: Interactor!
    }
}

// MARK: - Presentation logic

extension EmployeeList.Presenter: EmployeeListPresenting {

    func viewDidLoad() {}
    
    func didTapRemoveItem(at indexPath: IndexPath) {
        interactor.removeItem(at: indexPath)
    }
    
    func titleForHeader(in secion: Int) -> String? {
        switch secion {
        case 0:
            return R.string.common.accountantsSectionHeader()
        case 1:
            return R.string.common.employeesSectionHeader()
        case 2:
            return R.string.common.managerSectionHeader()
        default:
            return nil
        }
    }
    
    func item(at indexPath: IndexPath) -> EmployeeList.Cell {
        let item = interactor.item(at: indexPath)
        return .init(type: viewModel(entity: item), didSelect: didSelectItemCommand(at: indexPath))
    }
    
    func numberOfSections() -> Int {
        return interactor.numberOfSections()
    }
    
    func numberOfItems(in section: Int) -> Int {
        return interactor.numberOfItems(in: section)
    }
    
    func didTapAddButton() {
        router.navigateToUpdateEmployee(mode: .create(employeeType: .employee), output: self)
    }
    
    func didMoveItem(from old: IndexPath, to new: IndexPath) {
        interactor.moveItem(from: old, to: new)
    }
}

// MARK: - EmployeeListInteractorOutput

extension EmployeeList.Presenter: EmployeeListInteractorOutput {

    func didUpdateEntity() {
        view.viewModel = .reload
    }
}

// MARK: - Actions

private extension EmployeeList.Presenter {
    
    func didSelectItemCommand(at indexPath: IndexPath) -> Command {
        return Command { [weak self] in
            guard let self = self else {
                return
            }
            let item = self.interactor.item(at: indexPath)
            self.router.navigateToUpdateEmployee(mode: .update(entity: item), output: self)
        }
    }
}

// MARK: - ViewModel

private extension EmployeeList.Presenter {
    
    func viewModel(entity: EmployeeList.Entity) -> EmployeeList.CellType {
        switch entity.item {
        case .manager(let manager):
            return .manager(.init(name: manager.name,
                                  salary: R.string.common.salaryText(String(manager.salary)),
                                  receptionHours: R.string.common.receptionHoursText(manager.receptionHours)))
        case .accountant(let accountant):
            return .accountant(.init(name: accountant.name,
                                     salary: R.string.common.salaryText(String(accountant.salary)),
                                     lunchTime: R.string.common.lunchTimeText(accountant.lunchTime),
                                     workplaceNumber: R.string.common.workplaceNumberText(String(accountant.workplaceNumber)),
                                     type: R.string.common.accountantTypeText(accountant.type.rawValue)))
        case .employee(let employee):
            return .employee(.init(name: employee.name,
                                   salary: R.string.common.salaryText(String(employee.salary)),
                                   lunchTime: employee.lunchTime,
                                   workplaceNumber: R.string.common.workplaceNumberText(String(employee.workplaceNumber))))
        }
    }
}

// MARK: - UpdateEmployeePresenterOutput

extension EmployeeList.Presenter: UpdateEmployeePresenterOutput {
    
    func didUpdateEntity(_ presenter: UpdateEmployeePresenting, entity: UpdateEmployee.Entity) {
        interactor.insert(item: entity)
    }
}
