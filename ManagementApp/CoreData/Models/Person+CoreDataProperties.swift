//
//  Person+CoreDataProperties.swift
//  
//
//  Created by maxim kryuchkov on 04.11.2019.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String
    @NSManaged public var salary: Int32
    @NSManaged public var orderNumber: Float
}
