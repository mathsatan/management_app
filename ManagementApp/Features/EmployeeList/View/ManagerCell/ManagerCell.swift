//
//  ManagerCell.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

final class ManagerCell: UITableViewCell {
    
    struct ViewModel {
        let name: String
        let salary: String
        let receptionHours: String
        
        static let initial = ViewModel(name: "", salary: "", receptionHours: "")
    }
    
    // MARK: - Outlets
    
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var salaryLabel: UILabel!
    @IBOutlet private var receptionHours: UILabel!
    
    // MARK: - Public properties
    
    var viewModel: ViewModel = .initial {
        didSet {
            render(viewModel: viewModel)
        }
    }
    
    // MARK: - Private methods
    
    private func render(viewModel: ViewModel) {
        iconImageView.image = R.image.gallery()
        nameLabel.text = viewModel.name
        salaryLabel.text = viewModel.salary
        receptionHours.text = viewModel.receptionHours
    }
}

// MARK: - Height

extension ManagerCell {
    
    static func height() -> CGFloat {
        return 88.0
    }
}
