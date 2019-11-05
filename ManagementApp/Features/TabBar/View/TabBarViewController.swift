//
//  TabBarViewController.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

final class TabBarViewController: UITabBarController {

    // MARK: - Public properties

    var presenter: TabBarPresenting!

    // MARK: - Object lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        TabBar.Module().configure(viewController: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        presenter.viewDidLoad()
    }
}

// MARK: - View logic

extension TabBarViewController: TabBarView {
    
    func render(with viewModel: TabBarViewController.ViewModel) {
        switch viewModel {
        case .presenting(let viewControllers):
            setViewControllers(viewControllers, animated: false)
        }
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
