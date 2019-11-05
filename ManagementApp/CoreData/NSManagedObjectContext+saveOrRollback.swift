//
//  NSManagedObjectContext+saveOrRollback.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 6/20/19.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
}
