//
//  EmployeeListViewController.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

final class EmployeeListViewController: BaseViewController, EmployeeListView {
    
    var viewModel: EmployeeListViewController.ViewModel? {
        didSet {
            guard let viewModel = viewModel, isViewLoaded else {
                return
            }
            render(viewModel: viewModel)
        }
    }
    
    // MARK: - Public properties

    var presenter: EmployeeListPresenting!

    // MARK: - Outlets
    
    @IBOutlet private var tableView: UITableView!

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        presenter.viewDidLoad()
    }
    
    private func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(R.nib.managerCell)
        tableView.register(R.nib.accountantCell)
        tableView.register(R.nib.employeeCell)
        tableView.tableFooterView = UIView()
        navigationItem.title = R.string.tabBar.listItemTitle()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                           target: self,
                                                           action: #selector(addButtonAction))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: R.string.common.editBarButtonTitle(),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(editButtonAction))
    }
}

// MARK: - View logic

private extension EmployeeListViewController {

    func render(viewModel: EmployeeListViewController.ViewModel) {
        switch viewModel {
        case .presenting:
            tableView.reloadData()
        default:
            break
        }
    }
}

// MARK: - Actions

private extension EmployeeListViewController {

    @objc
    func addButtonAction() {
        presenter.didTapAddButton()
    }
    
    @objc
    func editButtonAction() {
        tableView.isEditing = !tableView.isEditing
        navigationItem.rightBarButtonItem?.title = tableView.isEditing ? R.string.common.doneBarButtonTitle() : R.string.common.editBarButtonTitle()
    }
}

// MARK: - UITableViewDelegate

extension EmployeeListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.item(at: indexPath).didSelect.perform()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        guard sourceIndexPath.section == proposedDestinationIndexPath.section else {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        presenter.didMoveItem(from: sourceIndexPath, to: destinationIndexPath)
    }
}

// MARK: - UITableViewDataSource

extension EmployeeListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.titleForHeader(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.didTapRemoveItem(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.item(at: indexPath)
        switch item.type {
        case .manager(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.managerCell, for: indexPath)!
            cell.viewModel = viewModel
            return cell
        case .accountant(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.accountantCell, for: indexPath)!
            cell.viewModel = viewModel
            return cell
        case .employee(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.employeeCell, for: indexPath)!
            cell.viewModel = viewModel
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch presenter.item(at: indexPath).type {
        case .accountant:
            return AccountantCell.height()
        case .employee:
            return EmployeeCell.height()
        case .manager:
            return ManagerCell.height()
        }
    }
}
