//
//  Accountant+CoreDataProperties.swift
//  
//
//  Created by maxim kryuchkov on 04.11.2019.
//
//

import Foundation
import CoreData


extension Accountant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Accountant> {
        return NSFetchRequest<Accountant>(entityName: "Accountant")
    }

    @NSManaged public var type: AccountantType?

}
