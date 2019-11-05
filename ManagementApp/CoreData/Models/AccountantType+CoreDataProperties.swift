//
//  AccountantType+CoreDataProperties.swift
//  
//
//  Created by maxim kryuchkov on 04.11.2019.
//
//

import Foundation
import CoreData


extension AccountantType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountantType> {
        return NSFetchRequest<AccountantType>(entityName: "AccountantType")
    }

    @NSManaged public var name: String?
    @NSManaged public var accountant: NSSet?

}

// MARK: Generated accessors for accountant
extension AccountantType {

    @objc(addAccountantObject:)
    @NSManaged public func addToAccountant(_ value: Accountant)

    @objc(removeAccountantObject:)
    @NSManaged public func removeFromAccountant(_ value: Accountant)

    @objc(addAccountant:)
    @NSManaged public func addToAccountant(_ values: NSSet)

    @objc(removeAccountant:)
    @NSManaged public func removeFromAccountant(_ values: NSSet)

}
