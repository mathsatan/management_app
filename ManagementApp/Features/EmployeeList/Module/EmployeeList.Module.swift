//
//  EmployeeList.Module.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

struct EmployeeList {}

extension EmployeeList {

    struct Module {

        func configure(viewController: EmployeeListViewController) {

            let router = Router()
            router.viewController = viewController

            let presenter = Presenter<Interactor>()
            presenter.view = viewController
            presenter.router = router

            let interactor = Interactor()
            interactor.output = presenter

            presenter.interactor = interactor

            viewController.presenter = presenter
        }
    }
}
