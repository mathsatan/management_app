//
//  UpdateEmployeeView.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

protocol UpdateEmployeeView: AnyObject {

    var viewModel: UpdateEmployeeViewController.ViewModel? { get set }
}

extension UpdateEmployeeViewController {

    struct ViewModel {
        let mode: Mode
        let segment: Int
        let content: Content
        
        enum Mode {
            case create
            case update
        }
        
        enum Content {
            case accountant(AccountantView.ViewModel)
            case employee(EmployeeView.ViewModel)
            case manager(ManagerView.ViewModel)
        }
    }
}
