//
//  EmployeeEntity.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import Foundation

struct EmployeeEntity {
    let id: Int
    let item: Item
    
    enum Item {
        case accountant(Accountant)
        case employee(Employee)
        case manager(Manager)
    }
    
    var type: EmployeeType {
        switch self.item {
        case .accountant:
            return .accountant
        case .employee:
            return .employee
        case .manager:
            return .manager
        }
    }
}

enum EmployeeType: Int {
    case accountant
    case employee
    case manager
}

extension EmployeeEntity {
    
    struct Accountant {
        let name: String
        let salary: Int32
        let lunchTime: String
        let workplaceNumber: Int32
        let type: AccountantType
        
        enum AccountantType: String {
            case payroll
            case materials
            case none
        }
        
        static func initial() -> Self {
            return .init(name: "", salary: 0, lunchTime: "", workplaceNumber: 0, type: .none)
        }
    }
    
    struct Employee {
        let name: String
        let salary: Int32
        let lunchTime: String
        let workplaceNumber: Int32
        
        static func initial() -> Self {
            return .init(name: "", salary: 0, lunchTime: "", workplaceNumber: 0)
        }
    }
    
    struct Manager {
        let name: String
        let salary: Int32
        let receptionHours: String
        
        static func initial() -> Self {
            return .init(name: "", salary: 0, receptionHours: "")
        }
    }
}
