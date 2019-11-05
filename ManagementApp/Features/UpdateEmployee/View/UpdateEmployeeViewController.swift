//
//  UpdateEmployeeViewController.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

final class UpdateEmployeeViewController: BaseViewController, UpdateEmployeeView {

    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel, isViewLoaded else {
                return
            }
            render(viewModel: viewModel)
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private var topNavigationItem: UINavigationItem!
    @IBOutlet private var typeSegmentedControl: UISegmentedControl!
    @IBOutlet private var accountantView: AccountantView!
    @IBOutlet private var employeeView: EmployeeView!
    @IBOutlet private var managerView: ManagerView!
    
    // MARK: - Public properties

    var presenter: UpdateEmployeePresenting!

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        presenter.viewDidLoad()
    }
}

// MARK: - Actions

extension UpdateEmployeeViewController {
    
    @IBAction func segmentedControlValueChangedAction(_ sender: UISegmentedControl) {
        presenter.didChangeSegmentIndex(sender.selectedSegmentIndex)
    }
    
    @objc
    func saveButtonAction() {
        if let content = prepareContent() {
            presenter.didObtainContent(content)
        }
        presenter.didTapSaveButton()
    }
    
    @objc
    func cancelButtonAction() {
        presenter.didTapCancelButton()
    }
}

// MARK: - Private methods

private extension UpdateEmployeeViewController {
    
    func configureView() {
        topNavigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveButtonAction))
        topNavigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                   target: self,
                                                                   action: #selector(cancelButtonAction))
    }
    
    func render(viewModel: ViewModel) {
        switch viewModel.mode {
        case .create:
            topNavigationItem.title = R.string.common.createTitle()
            typeSegmentedControl.isUserInteractionEnabled = true
        case .update:
            topNavigationItem.title = R.string.common.updateTitle()
            typeSegmentedControl.isUserInteractionEnabled = false
        }
        typeSegmentedControl.selectedSegmentIndex = viewModel.segment
        
        accountantView.isHidden = true
        employeeView.isHidden = true
        managerView.isHidden = true
        switch viewModel.content {
        case .accountant(let accountant):
            accountantView.isHidden = false
            accountantView.viewModel = accountant
        case .employee(let employee):
            employeeView.isHidden = false
            employeeView.viewModel = employee
        case .manager(let manager):
            managerView.isHidden = false
            managerView.viewModel = manager
        }
    }
    
    func prepareContent() -> ViewModel.Content? {
        guard let content = viewModel?.content else {
            return nil
        }
        switch content {
        case .accountant:
            return .accountant(accountantView.content())
        case .employee:
            return .employee(employeeView.content())
        case .manager:
            return .manager(managerView.content())
        }
    }
}
