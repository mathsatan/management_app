//
//  TabBar.Entity.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

extension TabBar {
    
    enum Entity: CaseIterable {
        
        case list
        case gallery
        
        var viewController: UIViewController {
            switch self {
            case .list:
                let viewController = EmployeeList.Router.initialViewController()
                viewController.tabBarItem.title = title
                viewController.tabBarItem.image = image
                EmployeeList.Module().configure(viewController: viewController)
                return UINavigationController(rootViewController: viewController)
            case .gallery:
                
                let viewController = Gallery.Router.initialViewController()
                viewController.tabBarItem.title = title
                viewController.tabBarItem.image = image
                Gallery.Module().configure(viewController: viewController)
                return UINavigationController(rootViewController: viewController)
            }
        }
       
        var image: UIImage? {
            switch self {
            case .list:
                return R.image.list()!
            case .gallery:
                return R.image.gallery()!
            }
        }
        
        var title: String {
            
            let title: String
            switch self {
            case .list:
                title = R.string.tabBar.listItemTitle()
            case .gallery:
                title = R.string.tabBar.galleryItemTitle()
            }
            
            return title
        }
    }
}
