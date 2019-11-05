//
//  EmployeeCell.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

final class AccountantCell: UITableViewCell {
    
    struct ViewModel {
        let name: String
        let salary: String
        let lunchTime: String
        let workplaceNumber: String
        let type: String
        
        static let initial = ViewModel(name: "", salary: "", lunchTime: "", workplaceNumber: "", type: "")
    }
    
    // MARK: - Outlets
    
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var salaryLabel: UILabel!
    @IBOutlet private var lunchTimeLabel: UILabel!
    @IBOutlet private var workplaceNumberLabel: UILabel!
    @IBOutlet private var typeLabel: UILabel!
    
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
        lunchTimeLabel.text = viewModel.lunchTime
        workplaceNumberLabel.text = viewModel.workplaceNumber
        typeLabel.text = viewModel.type
    }
}

// MARK: - Height

extension AccountantCell {
    
    static func height() -> CGFloat {
        return 130.0
    }
}
