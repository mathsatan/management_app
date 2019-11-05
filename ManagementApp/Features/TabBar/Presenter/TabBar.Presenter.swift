//
//  TabBar.Presenter.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

protocol TabBarPresenting: AnyObject {

    func viewDidLoad()
}

extension TabBar {

    final class Presenter {

        // MARK: - Public properties

        weak var view: TabBarView!
        var router: TabBarRouting!
        var interactor: TabBarInteracting!
    }
}

// MARK: - Presentation logic

extension TabBar.Presenter: TabBarPresenting {

    func viewDidLoad() {
        view.render(with: .presenting(interactor.viewControllers))
        router.showItemAt(interactor.index(of: TabBar.Entity.list)!)
    }
}
