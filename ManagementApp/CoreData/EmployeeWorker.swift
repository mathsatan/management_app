//
//  EmployeeWorker.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import Foundation
import CoreData

final class EmployeeWorker: NSObject {
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        super.init()
        self.presetAccountantTypesIfNeeded()
    }
    
    private(set)var fetchedObjects: [Person] = []
    private(set)var accountantTypes: [AccountantType] = []
    
    var isDefaultSort: Bool {
        return (fetchedObjects.reduce(0.0) { $0 + $1.orderNumber }).isZero
    }
    
    func insert(item: EmployeeEntity, isDefaultSort: Bool, onComplete: @escaping CoreDataResultCallback<Bool>) {
        let context = coreDataStack.mainContext
        context.perform { [weak self] in
            guard let self = self,
                let entityDescription = self.entityDescription(for: item, in: context) else {
                onComplete(.success(false))
                return
            }
            _ = self.create(for: item, isDefaultSort: isDefaultSort, entityDescription: entityDescription, in: context)
            self.saveContextIfNeeded(context, onComplete: onComplete)
        }
    }
    
    func update(item: EmployeeEntity, onComplete: @escaping CoreDataResultCallback<Bool>) {
        let context = coreDataStack.mainContext
        switch item.item {
        case .accountant(let data):
            guard let accountant = fetchedObjects[item.id] as? Accountant else {
                onComplete(.success(false))
                return
            }
            _ = copyAccountantData(from: data, to: accountant, orderNumber: nil)
        case .employee(let data):
            guard let employee = fetchedObjects[item.id] as? Employee else {
                onComplete(.success(false))
                return
            }
            _ = copyEmployeeData(from: data, to: employee, orderNumber: nil)
        case .manager(let data):
            guard let manager = fetchedObjects[item.id] as? Manager else {
                onComplete(.success(false))
                return
            }
            _ = copyManagerData(from: data, to: manager, orderNumber: nil)
        }
        saveContextIfNeeded(context, onComplete: onComplete)
    }
    
    func assignIndexes(to persons: [Person], onComplete: @escaping CoreDataResultCallback<Bool>) {
        let context = coreDataStack.mainContext
        context.perform {
            persons.enumerated().forEach { $0.element.orderNumber = Float($0.offset + 1) }
            self.saveContextIfNeeded(context, onComplete: onComplete)
        }
    }
    
    func update(orderNumber: Float, for person: Person, onComplete: @escaping CoreDataResultCallback<Bool>) {
        let context = coreDataStack.mainContext
        context.perform {
            person.orderNumber = orderNumber
            self.saveContextIfNeeded(context, onComplete: onComplete)
        }
    }
    
    func delete(item: NSManagedObject) -> Bool {
        coreDataStack.mainContext.delete(item)
        return coreDataStack.mainContext.saveOrRollback()
    }
    
    func deleteAll() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Employee.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try coreDataStack.mainContext.persistentStoreCoordinator?.execute(deleteRequest,
                                                                          with: coreDataStack.backgroundContext)
    }
    
    @discardableResult
    func fetchItems() -> Bool {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.sortDescriptors = Person.defaultSortDescriptors
        request.returnsObjectsAsFaults = false
        do {
            fetchedObjects = try coreDataStack.mainContext.fetch(request)
            return true
        } catch {
            print("Fetch error: \(error)")
            return false
        }
    }
}

// MARK: - Private methods

private extension EmployeeWorker {
    
    func saveContextIfNeeded(_ context: NSManagedObjectContext, onComplete: @escaping CoreDataResultCallback<Bool>) {
        guard context.hasChanges else {
            onComplete(.success(false))
            return
        }
        onComplete(self.saveOrRollback(context: context))
    }
    
    func presetAccountantTypesIfNeeded() {
        let request: NSFetchRequest<AccountantType> = AccountantType.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let context = coreDataStack.mainContext
            accountantTypes = try context.fetch(request)
            if accountantTypes.isEmpty {
                context.perform { [weak self] in
                    guard let description = NSEntityDescription.entity(forEntityName: "AccountantType", in: context) else {
                        return
                    }
                    let payroll = AccountantType(entity: description, insertInto: context)
                    let materials = AccountantType(entity: description, insertInto: context)
                    payroll.name = "payroll"
                    materials.name = "materials"
                    self?.saveContextIfNeeded(context) { _ in }
                }
            }
        } catch {
            print("Fetch error: \(error)")
        }
    }
    
    func saveOrRollback(context: NSManagedObjectContext) -> Result<Bool, Error> {
        do {
            try context.save()
            return .success(true)
        } catch {
            context.rollback()
            return .failure(error)
        }
    }
    
    func create(for entity: EmployeeEntity,
                isDefaultSort: Bool,
                entityDescription: NSEntityDescription,
                in context: NSManagedObjectContext) -> Person {
        let orderNumber = isDefaultSort ? 0.0 : Float(fetchedObjects.count + 1)
        switch entity.item {
        case .accountant(let data):
            let accountant = Accountant(entity: entityDescription, insertInto: context)
            return copyAccountantData(from: data, to: accountant, orderNumber: orderNumber)
        case .employee(let data):
            let employee = Employee(entity: entityDescription, insertInto: context)
            return copyEmployeeData(from: data, to: employee, orderNumber: orderNumber)
        case .manager(let data):
            let manager = Manager(entity: entityDescription, insertInto: context)
            return copyManagerData(from: data, to: manager, orderNumber: orderNumber)
        }
    }
    
    func entityDescription(for entity: EmployeeEntity, in context: NSManagedObjectContext) -> NSEntityDescription? {
        switch entity.item {
        case .accountant:
            return NSEntityDescription.entity(forEntityName: "Accountant", in: context)
        case .employee:
            return NSEntityDescription.entity(forEntityName: "Employee", in: context)
        case .manager:
            return NSEntityDescription.entity(forEntityName: "Manager", in: context)
        }
    }
    
    func copyAccountantData(from accountant: EmployeeEntity.Accountant, to data: Accountant, orderNumber: Float?) -> Accountant {
        if let orderNumber = orderNumber {
            data.orderNumber = orderNumber
        }
        data.name = accountant.name
        data.lunch_time = accountant.lunchTime
        data.salary = accountant.salary
        data.workplace_number = accountant.workplaceNumber
        data.type = accountantTypes.first { $0.name == accountant.type.rawValue }
        return data
    }
    
    func copyEmployeeData(from employee: EmployeeEntity.Employee, to data: Employee, orderNumber: Float?) -> Employee {
        if let orderNumber = orderNumber {
            data.orderNumber = orderNumber
        }
        data.name = employee.name
        data.salary = employee.salary
        data.workplace_number = employee.workplaceNumber
        return data
    }
    
    func copyManagerData(from manager: EmployeeEntity.Manager, to data: Manager, orderNumber: Float?) -> Manager {
        if let orderNumber = orderNumber {
            data.orderNumber = orderNumber
        }
        data.name = manager.name
        data.salary = manager.salary
        data.reception_hours = manager.receptionHours
        return data
    }
}
