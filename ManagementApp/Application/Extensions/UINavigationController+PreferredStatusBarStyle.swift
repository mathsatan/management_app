//
//  UINavigationController+PreferredStatusBarStyle.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .black
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
