//
//  TabBar.Router.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

protocol TabBarRouting {

    func initialViewController() -> TabBarViewController
    func showItemAt(_ index: Int)
}

extension TabBar {

    final class Router {

        // MARK: - Public properties

        weak var viewController: TabBarViewController!
    }
}

// MARK: - Navigation

extension TabBar.Router: TabBarRouting {
    func initialViewController() -> TabBarViewController {
        return R.storyboard.tabBar.tabBarViewController()!
    }

    func showItemAt(_ index: Int) {
        viewController.selectedIndex = index
    }
}
