//
//  UpdateEmployee.Module.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

struct UpdateEmployee {}

extension UpdateEmployee {

    struct Module {

        let mode: UpdateEmployee.Mode
        let presenterOutput: UpdateEmployeePresenterOutput
        
        func configure(viewController: UpdateEmployeeViewController) {

            let router = Router()
            router.viewController = viewController

            let presenter = Presenter()
            presenter.view = viewController
            presenter.router = router
            presenter.presenterOutput = presenterOutput

            let interactor = Interactor(mode: mode)
            interactor.output = presenter

            presenter.interactor = interactor

            viewController.presenter = presenter
        }
    }
}
