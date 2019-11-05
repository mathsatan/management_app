//
//  TabBar.Interactor.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

protocol TabBarInteracting: AnyObject {
    
    var viewControllers: [UIViewController] { get }
    
    func index(of item: TabBar.Entity) -> Int?
    func item(for viewController: UIViewController) -> TabBar.Entity?
}

extension TabBar {

    final class Interactor {

        // MARK: - Public properties

        let viewControllers: [UIViewController]
        let items: [Entity]

        // MARK: - Init

        init(items: [Entity]) {
            self.items = items
            self.viewControllers = items.compactMap { $0.viewController }
        }
    }
}

// MARK: - Business logic

extension TabBar.Interactor: TabBarInteracting {
    
    func index(of item: TabBar.Entity) -> Int? {
        return items.firstIndex(of: item)
    }
    
    func item(for viewController: UIViewController) -> TabBar.Entity? {
        guard let index = viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        return items[index]
    }
}
