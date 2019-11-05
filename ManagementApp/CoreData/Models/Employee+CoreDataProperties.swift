//
//  Employee+CoreDataProperties.swift
//  
//
//  Created by maxim kryuchkov on 04.11.2019.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var lunch_time: String
    @NSManaged public var workplace_number: Int32

}
