//
//  ManagerView.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

final class ManagerView: UIView {
    
    // MARK: - Public properties
    
    var viewModel: ViewModel = .initial() {
        didSet {
            render(viewModel: viewModel)
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var salaryTextField: UITextField!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var receptionHoursTextField: UITextField!
    
    // MARK: - Public methods
    
    func content() -> ViewModel {
        return .init(name: nameTextField.text ?? "",
                     salary: salaryTextField.text ?? "",
                     receptionHours: receptionHoursTextField.text ?? "")
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.managerView.name, owner: self, options: nil)
        addSubviewWithDefaultConstraints(containerView)
        nameTextField.placeholder = R.string.common.namePlaceholder()
        salaryTextField.placeholder = R.string.common.salaryPlaceholder()
        receptionHoursTextField.placeholder = R.string.common.receptionHoursPlaceholder()
        salaryTextField.keyboardType = .numberPad
    }
    
    private func render(viewModel: ViewModel) {
        nameTextField.text = viewModel.name
        salaryTextField.text = viewModel.salary
        receptionHoursTextField.text = viewModel.receptionHours
    }
}

// MARK: - ViewModel

extension ManagerView {
    
    struct ViewModel {
        let name: String
        let salary: String
        let receptionHours: String
        
        static func initial() -> ViewModel {
            return .init(name: "", salary: "", receptionHours: "")
        }
    }
}
