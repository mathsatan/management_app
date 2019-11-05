//
//  UpdateEmployee.Router.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

protocol UpdateEmployeeRouting {

    func close()
}

extension UpdateEmployee {

    final class Router {

        // MARK: - Public properties

        weak var viewController: UpdateEmployeeViewController!
        
        static func initialViewController() -> UpdateEmployeeViewController {
            return R.storyboard.updateEmployee.updateEmployeeViewController()!
        }
    }
}

// MARK: - Navigation

extension UpdateEmployee.Router: UpdateEmployeeRouting {    

    func close() {
        viewController.presentingViewController?.dismiss(animated: true)
    }
}
