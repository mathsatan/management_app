//
//  TabBar.Module.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

struct TabBar {}

extension TabBar {

    struct Module {
        let items: [Entity]
        
        init(items: [Entity] = Entity.allCases) {
            self.items = items
        }
        
        func configure(viewController: TabBarViewController) {

            let router = Router()
            router.viewController = viewController

            let presenter = Presenter()
            presenter.view = viewController
            presenter.router = router

            let interactor = Interactor(items: items)

            presenter.interactor = interactor

            viewController.presenter = presenter
        }
    }
}
