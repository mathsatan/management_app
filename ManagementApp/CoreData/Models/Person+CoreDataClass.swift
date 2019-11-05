//
//  Person+CoreDataClass.swift
//  
//
//  Created by maxim kryuchkov on 04.11.2019.
//
//

import Foundation
import CoreData

@objc(Person)
public class Person: NSManagedObject {

    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(orderNumber), ascending: true),
                NSSortDescriptor(key: #keyPath(name), ascending: true)]
    }
}
