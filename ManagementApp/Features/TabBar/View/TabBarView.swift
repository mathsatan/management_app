//
//  TabBarView.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

protocol TabBarView: AnyObject {
    func render(with viewModel: TabBarViewController.ViewModel)
}

extension TabBarViewController {
    enum ViewModel {
        case presenting([UIViewController])
    }
}
