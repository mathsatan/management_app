//
//  EmployeeList.Router.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

protocol EmployeeListRouting {

    func navigateToUpdateEmployee(mode: UpdateEmployee.Mode, output: UpdateEmployeePresenterOutput)
}

extension EmployeeList {

    final class Router {

        // MARK: - Public properties

        weak var viewController: EmployeeListViewController!
        
        static func initialViewController() -> EmployeeListViewController {
             return R.storyboard.employeeList.employeeListViewController()!
        }
    }
}

// MARK: - Navigation

extension EmployeeList.Router: EmployeeListRouting {    

    func navigateToUpdateEmployee(mode: UpdateEmployee.Mode, output: UpdateEmployeePresenterOutput) {
        let updateEmployeeViewController = UpdateEmployee.Router.initialViewController()
        let module = UpdateEmployee.Module(mode: mode, presenterOutput: output)
        module.configure(viewController: updateEmployeeViewController)
        viewController.present(updateEmployeeViewController, animated: true)
    }
}
