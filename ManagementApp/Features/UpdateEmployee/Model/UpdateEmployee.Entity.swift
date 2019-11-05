//
//  UpdateEmployee.Entity.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import Foundation

extension UpdateEmployee {

    typealias Entity = EmployeeEntity
    
    enum Mode {
        case create(employeeType: EmployeeType)
        case update(entity: Entity)
        
        var employeeType: EmployeeType? {
            switch self {
            case .create(let employeeType):
                return employeeType
            case .update:
                return nil
            }
        }
    }
}
