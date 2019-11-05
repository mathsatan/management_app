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
    
    func insert(item: EmployeeEntity, onComplete: @escaping CoreDataResultCallback<Bool>) {
        let context = coreDataStack.mainContext
        context.perform { [weak self] in
            guard let self = self,
                let entityDescription = self.entityDescription(for: item, in: context) else {
                onComplete(.success(false))
                return
            }
            _ = self.create(for: item, entityDescription: entityDescription, in: context)
            guard context.hasChanges else {
                onComplete(.success(false))
                return
            }
            
            let result = self.saveOrRollback(context: context)
            onComplete(result)
        }
    }
    
    func update(person: Person, orderNumber: Float, onComplete: @escaping CoreDataResultCallback<Bool>) {
        let context = coreDataStack.mainContext
        context.perform {
            person.orderNumber = orderNumber
            guard context.hasChanges else {
                onComplete(.success(false))
                return
            }
            let result = self.saveOrRollback(context: context)
            
            print("::urder - \(self.fetchedObjects.compactMap { "\($0.name) -> \($0.orderNumber)\n" })")
            onComplete(result)
        }
    }
    
    func presetAccountantTypesIfNeeded() {
        let request: NSFetchRequest<AccountantType> = AccountantType.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            accountantTypes = try coreDataStack.mainContext.fetch(request)
            if accountantTypes.isEmpty {
                let context = coreDataStack.mainContext
                context.perform { [weak self] in
                    guard let description = NSEntityDescription.entity(forEntityName: "AccountantType", in: context) else {
                        return
                    }
                    let payroll = AccountantType(entity: description, insertInto: context)
                    let materials = AccountantType(entity: description, insertInto: context)
                    payroll.name = "payroll"
                    materials.name = "materials"
                    if context.hasChanges {
                        _ = self?.saveOrRollback(context: context)
                    }
                }
            }
        } catch {
            print("Fetch error: \(error)")
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
            print("::order - \(fetchedObjects.compactMap { "\($0.name) -> \($0.orderNumber)\n" })")
            return true
        } catch {
            print("Fetch error: \(error)")
            return false
        }
    }
}

// MARK: - Save

private extension EmployeeWorker {
    
    func saveOrRollback(context: NSManagedObjectContext) -> Result<Bool, Error> {
        do {
            try context.save()
            return .success(true)
        } catch {
            context.rollback()
            return .failure(error)
        }
    }
    
    func create(for entity: EmployeeEntity, entityDescription: NSEntityDescription, in context: NSManagedObjectContext) -> Person {
        switch entity.item {
        case .accountant(let data):
            let accountant = Accountant(entity: entityDescription, insertInto: context)
            accountant.orderNumber = Float(fetchedObjects.count + 1)
            accountant.name = data.name
            accountant.lunch_time = data.lunchTime
            accountant.salary = data.salary
            accountant.workplace_number = data.workplaceNumber
            accountant.type = accountantTypes.first { $0.name == data.type.rawValue }
            return accountant
        case .employee(let data):
            let employee = Employee(entity: entityDescription, insertInto: context)
            employee.orderNumber = Float(fetchedObjects.count + 1)
            employee.name = data.name
            employee.salary = data.salary
            employee.workplace_number = data.workplaceNumber
            return employee
        case .manager(let data):
            let manager = Manager(entity: entityDescription, insertInto: context)
            manager.orderNumber = Float(fetchedObjects.count + 1)
            manager.name = data.name
            manager.salary = data.salary
            manager.reception_hours = data.receptionHours
            return manager
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
}
