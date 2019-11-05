//
//  ManagerView.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

final class EmployeeView: UIView {
    
    // MARK: - Public properties
    
    var viewModel: ViewModel = .initial() {
        didSet {
            render(viewModel: viewModel)
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private var containerVIew: UIView!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var salaryTextField: UITextField!
    @IBOutlet private var lunchTimeTextField: UITextField!
    @IBOutlet private var workplaceNumberTextField: UITextField!
    
    // MARK: - Public methods
    
    func content() -> ViewModel {
        return .init(name: nameTextField.text ?? "",
                     salary: salaryTextField.text ?? "",
                     lunchTime: lunchTimeTextField.text ?? "",
                     workplaceNumber: workplaceNumberTextField.text ?? "")
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
        Bundle.main.loadNibNamed(R.nib.employeeView.name, owner: self, options: nil)
        addSubviewWithDefaultConstraints(containerVIew)
        nameTextField.placeholder = R.string.common.namePlaceholder()
        salaryTextField.placeholder = R.string.common.salaryPlaceholder()
        lunchTimeTextField.placeholder = R.string.common.lunchTimePlaceholder()
        workplaceNumberTextField.placeholder = R.string.common.workplaceNumberPlaceholder()
        salaryTextField.keyboardType = .numberPad
        workplaceNumberTextField.keyboardType = .numberPad
    }
    
    private func render(viewModel: ViewModel) {
        nameTextField.text = viewModel.name
        salaryTextField.text = viewModel.salary
        lunchTimeTextField.text = viewModel.lunchTime
        workplaceNumberTextField.text = viewModel.workplaceNumber
    }
}

// MARK: - ViewModel

extension EmployeeView {
    
    struct ViewModel {
        let name: String
        let salary: String
        let lunchTime: String
        let workplaceNumber: String
        
        static func initial() -> ViewModel {
            return .init(name: "", salary: "", lunchTime: "", workplaceNumber: "")
        }
    }
}
