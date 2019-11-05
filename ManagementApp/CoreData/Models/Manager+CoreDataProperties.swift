//
//  Manager+CoreDataProperties.swift
//  
//
//  Created by maxim kryuchkov on 04.11.2019.
//
//

import Foundation
import CoreData


extension Manager {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Manager> {
        return NSFetchRequest<Manager>(entityName: "Manager")
    }

    @NSManaged public var reception_hours: String

}
