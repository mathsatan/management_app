//
//  EmployeeListView.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

protocol EmployeeListView: AnyObject {
    
    var viewModel: EmployeeListViewController.ViewModel? { get set }
}

extension EmployeeList {
    
    struct Cell {
        let type: CellType
        let didSelect: Command
    }
    
    enum CellType {
        case manager(ManagerCell.ViewModel)
        case accountant(AccountantCell.ViewModel)
        case employee(EmployeeCell.ViewModel)
    }
}

extension EmployeeListViewController {
    
    enum ViewModel {
        case loading
        case presenting
        case error(LocalizedError)
    }
}
