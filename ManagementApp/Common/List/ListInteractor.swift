//
//  ListInteractor.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import Foundation

protocol ListInteractor: AnyObject {
    
    associatedtype Item
    
    // MARK: - DataSource
    
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> Item
    func indexPath(where predicate: (Item) -> Bool) -> IndexPath?
    func item(where predicate: (Item) -> Bool) -> Item?
    func totalItems() -> Int
}

extension ListInteractor {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func indexPath(where predicate: (Item) -> Bool) -> IndexPath? {
        return nil
    }
    
    func item(where predicate: (Item) -> Bool) -> Item? {
        guard let indexPath = indexPath(where: predicate) else {
            return nil
        }
        
        return item(at: indexPath)
    }
    
    func totalItems() -> Int {
        
        let numberOfSections = self.numberOfSections()
        
        var total: Int = 0
        
        for section in 0..<numberOfSections {
            total += numberOfItems(in: section)
        }
        
        return total
    }
}
