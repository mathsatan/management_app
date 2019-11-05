//
//  ManagerView.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

final class AccountantView: UIView {
    
    var viewModel: ViewModel = .initial() {
        didSet {
            render(viewModel: viewModel)
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var salaryTextField: UITextField!
    @IBOutlet private var lunchTimeTextField: UITextField!
    @IBOutlet private var workplaceNumberTextField: UITextField!
    @IBOutlet private var typeTextField: UITextField!
    
    // MARK: - Public methods
    
    func content() -> ViewModel {
        return .init(name: nameTextField.text ?? "",
                     salary: salaryTextField.text ?? "",
                     lunchTime: lunchTimeTextField.text ?? "",
                     workplaceNumber: workplaceNumberTextField.text ?? "",
                     accountantTypes: [],
                     accountType: typeTextField.text ?? "")
    }
    
    // MARK: - Private properties
    
    private let typePicker = UIPickerView()
    
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
        Bundle.main.loadNibNamed(R.nib.accountantView.name, owner: self, options: nil)
        addSubviewWithDefaultConstraints(containerView)
        configureView()
    }
    
    private func render(viewModel: ViewModel) {
        nameTextField.text = viewModel.name
        salaryTextField.text = viewModel.salary
        lunchTimeTextField.text = viewModel.lunchTime
        workplaceNumberTextField.text = viewModel.workplaceNumber
        typeTextField.text = viewModel.accountType
    }
}

// MARK: - Private methods

private extension AccountantView {
    
    func configureView() {
        nameTextField.placeholder = R.string.common.namePlaceholder()
        salaryTextField.placeholder = R.string.common.salaryPlaceholder()
        lunchTimeTextField.placeholder = R.string.common.lunchTimePlaceholder()
        workplaceNumberTextField.placeholder = R.string.common.workplaceNumberPlaceholder()
        salaryTextField.keyboardType = .numberPad
        workplaceNumberTextField.keyboardType = .numberPad
        typePicker.delegate = self
        typePicker.dataSource = self
        typeTextField.inputView = typePicker
        typeTextField.inputAccessoryView = pickerToolBar()
    }
    
    func pickerToolBar() -> UIView {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapPickerDoneButton))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
}

// MARK: - Actions

private extension AccountantView {
    
    @objc
    func didTapPickerDoneButton() {
        endEditing(true)
    }
}

// MARK: - ViewModel

extension AccountantView {
    
    struct ViewModel {
        let name: String
        let salary: String
        let lunchTime: String
        let workplaceNumber: String
        let accountantTypes: [String]
        let accountType: String
        
        static func initial() -> ViewModel {
            return .init(name: "", salary: "", lunchTime: "", workplaceNumber: "", accountantTypes: [], accountType: "")
        }
    }
}

// MARK: - UIPickerViewDelegate

extension AccountantView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.accountantTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTextField.text = viewModel.accountantTypes[row]
    }
}

// MARK: - UIPickerViewDataSource

extension AccountantView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.accountantTypes.count
    }
}
